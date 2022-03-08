//
//  CXCallController+QuickStart.swift
//  QuickStart
//
//  Copyright © 2020 Sendbird, Inc. All rights reserved.
//

import Foundation
import CallKit
import UIKit
import AVFoundation
import SendBirdCalls

// This delegate reflects the changes made on CallKit view to the CallViewController. i.e. MuteButton's status.
protocol CXCallManagerDelegate: AnyObject {
    func didChangeAudioStatus(callId: String, isEnabled: Bool)
}

class CXCallManager: NSObject {
    static let shared = CXCallManager()
    
    static let CallsChangedNotification = Notification.Name("CallsChangedNotification")
    
    var currentCalls: [CXCall] { self.controller.callObserver.calls }
    var currentDirectCalls: [DirectCall] {
        self.currentCalls.compactMap { SendBirdCall.getCall(forUUID: $0.uuid) }
    }

    weak var delegate: CXCallManagerDelegate?
    
    private let provider: CXProvider = .default
    private let controller = CXCallController()
    
    override init() {
        super.init()
        self.controller.callObserver.setDelegate(self, queue: .main)
        self.provider.setDelegate(self, queue: .main)
    }
    
    func shouldProcessCall(for callId: UUID) -> Bool {
        return !self.currentCalls.contains(where: { $0.uuid == callId })
    }
}

extension CXCallManager { // Process with CXProvider
    func reportIncomingCall(with callID: UUID, update: CXCallUpdate, completionHandler: ((Error?) -> Void)? = nil) {
        self.provider.reportNewIncomingCall(with: callID, update: update) { (error) in
            completionHandler?(error)
        }
    }
    
    func endCall(for callId: UUID, endedAt: Date, reason: DirectCallEndResult) {
        guard let endReason = reason.asCXCallEndedReason else { return }

        self.provider.reportCall(with: callId, endedAt: endedAt, reason: endReason)
    }
    
    func connectedCall(_ call: DirectCall) {
        self.provider.reportOutgoingCall(with: call.callUUID!, connectedAt: Date(timeIntervalSince1970: Double(call.startedAt)/1000))
    }
    
    func updateCall(_ call: DirectCall) {
        guard let uuid = call.callUUID else { return }
        
        self.controller.request(CXTransaction(action: CXSetMutedCallAction(call: uuid, muted: !call.isLocalAudioEnabled))) { error in
            print("Updated call with error: \(error?.localizedDescription ?? "nil")")
        }
    }
}

extension CXCallManager { // Process with CXTransaction
    func requestTransaction(_ transaction: CXTransaction, completionHandler: (() -> Void)? = nil) {
        self.controller.request(transaction) { error in
            guard error == nil else {
                print("Error Requesting Transaction: \(String(describing: error))")
                completionHandler?()
                return
            }
            
            // Requested transaction successfully
            completionHandler?()
        }
    }
    
    func startCXCall(_ call: DirectCall, completionHandler: @escaping ((Bool) -> Void)) {
        guard let calleeId = call.callee?.userId else {
            DispatchQueue.main.async {
                completionHandler(false)
            }
            return
        }
        
        let handle = CXHandle(type: .generic, value: calleeId)
        let startCallAction = CXStartCallAction(call: call.callUUID!, handle: handle)
        startCallAction.isVideo = call.isVideoCall
        
        let transaction = CXTransaction(action: startCallAction)
        
        self.requestTransaction(transaction) {
            let update = CXCallUpdate()
            update.supportsHolding = true
            self.provider.reportCall(with: call.callUUID!, updated: update)
            
            DispatchQueue.main.async {
                completionHandler(true)
            }
        }
        self.postCallsChangedNotification()
    }
    
    func endCXCall(_ call: DirectCall) {
        let endCallAction = CXEndCallAction(call: call.callUUID!)
        let transaction = CXTransaction(action: endCallAction)
        
        self.requestTransaction(transaction)
        self.postCallsChangedNotification()
    }
    
    func setHoldCXCall(_ callId: UUID, isHold: Bool) {
        let setHeldCallAction = CXSetHeldCallAction(call: callId, onHold: isHold)
        let transaction = CXTransaction(action: setHeldCallAction)
        
        self.requestTransaction(transaction)
        self.postCallsChangedNotification()
    }
    
    private func postCallsChangedNotification() {
        NotificationCenter.default.post(name: Self.CallsChangedNotification, object: self)
    }
}

extension CXCallManager: CXProviderDelegate, CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        print("Call changed: \(call.uuid)")
    }
    
    func providerDidReset(_ provider: CXProvider) { }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        guard let call = SendBirdCall.getCall(forUUID: action.callUUID) else {
            action.fail()
            return
        }
        
        if call.myRole == .caller {
            provider.reportOutgoingCall(with: call.callUUID!, startedConnectingAt: Date(timeIntervalSince1970: Double(call.startedAt)/1000))
        }
        
        self.postCallsChangedNotification()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = SendBirdCall.getCall(forUUID: action.callUUID),
              SendBirdCall.currentUser != nil else {
            action.fail()
            return
        }
        
        let callOptions = CallOptions(isAudioEnabled: true, isVideoEnabled: call.isVideoCall, useFrontCamera: true)
        let acceptParams = AcceptParams(callOptions: callOptions, holdActiveCall: holdActiveCalls)
        call.accept(with: acceptParams)

        let presentingVC = UIViewController.topViewController?.presentingViewController
        if UIViewController.topViewController is CallViewController || UIViewController.topViewController is CallListTableViewController {
            UIViewController.topViewController?.dismiss(animated: true, completion: {
                UIApplication.shared.showCallController(with: call, on: presentingVC)
            })
        } else {
            UIApplication.shared.showCallController(with: call)
        }
        
        self.postCallsChangedNotification()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        print("\(#function) was called with callID: \(action.callUUID), isOnHold: \(action.isOnHold)")
        guard let call = SendBirdCall.getCall(forUUID: action.callUUID),
              SendBirdCall.currentUser != nil else {
            action.fail()
            return
        }
        
        if action.isOnHold {
            call.hold { error in
                print("Put a call on hold with error: \(String(describing: error))")
                guard error == nil else {
                    action.fail()
                    return
                }
                self.postCallsChangedNotification()
                action.fulfill()
            }
        } else {
            call.unhold(force: shouldForce) { error in
                print("Removed a hold from a call with error: \(String(describing: error))")
                guard error == nil else {
                    action.fail()
                    return
                }
                self.postCallsChangedNotification()
                action.fulfill()
            }
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let call = SendBirdCall.getCall(forUUID: action.callUUID) else {
            action.fail()
            return
        }
        
        if call.endResult == .none || call.endResult == .unknown {
            call.end()
        }
        
        self.postCallsChangedNotification()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let delegate = self.delegate else {
            action.fail()
            return
        }
        
        delegate.didChangeAudioStatus(callId: action.callUUID.uuidString, isEnabled: !action.isMuted)
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        SendBirdCall.audioSessionDidActivate(audioSession)
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        SendBirdCall.audioSessionDidDeactivate(audioSession)
    }
}

extension DirectCallEndResult {
    var asCXCallEndedReason: CXCallEndedReason? {
        switch self {
        case .connectionLost, .timedOut, .acceptFailed, .dialFailed, .unknown:
            return .failed
        case .completed, .canceled:
            return .remoteEnded
        case .declined:
            return .declinedElsewhere
        case .noAnswer:
            return .unanswered
        case .otherDeviceAccepted:
            return .answeredElsewhere
        case .none: return nil
        @unknown default: return nil
        }
    }
}
