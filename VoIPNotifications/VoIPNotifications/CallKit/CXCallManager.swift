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
    
    var currentCalls: [CXCall] { self.controller.callObserver.calls }
    
    weak var delegate: CXCallManagerDelegate?
    
    private let provider: CXProvider = .default
    private let controller = CXCallController()
    
    override init() {
        super.init()
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
    func requestTransaction(_ transaction: CXTransaction, action: String = "") {
        self.controller.request(transaction) { error in
            guard error == nil else {
                print("Error Requesting Transaction: \(String(describing: error))")
                return
            }
            // Requested transaction successfully
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
        
        self.requestTransaction(transaction)
        
        DispatchQueue.main.async {
            completionHandler(true)
        }
    }
    
    func endCXCall(_ call: DirectCall) {
        let endCallAction = CXEndCallAction(call: call.callUUID!)
        let transaction = CXTransaction(action: endCallAction)
        
        self.requestTransaction(transaction)
    }
}

extension CXCallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) { }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        guard let call = SendBirdCall.getCall(forUUID: action.callUUID) else {
            action.fail()
            return
        }
        
        if call.myRole == .caller {
            provider.reportOutgoingCall(with: call.callUUID!, startedConnectingAt: Date(timeIntervalSince1970: Double(call.startedAt)/1000))
        }
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = SendBirdCall.getCall(forUUID: action.callUUID),
              SendBirdCall.currentUser != nil else {
            action.fail()
            return
        }
        
        let callOptions = CallOptions(isAudioEnabled: true, isVideoEnabled: call.isVideoCall, useFrontCamera: true)
        let acceptParams = AcceptParams(callOptions: callOptions)
        call.accept(with: acceptParams)
        UIApplication.shared.showCallController(with: call)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let call = SendBirdCall.getCall(forUUID: action.callUUID) else {
            action.fail()
            return
        }
        
        var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
        
        // For decline in background
        DispatchQueue.global().async {
            backgroundTaskID = UIApplication.shared.beginBackgroundTask {
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
                backgroundTaskID = .invalid
            }
            
            if call.endResult == .none || call.endResult == .unknown {
                call.end {
                    action.fulfill()
                    
                    // End background task
                    UIApplication.shared.endBackgroundTask(backgroundTaskID)
                    backgroundTaskID = .invalid
                }
            } else {
                action.fulfill()
            }
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let delegate = self.delegate else {
            action.fail()
            return
        }
        
        delegate.didChangeAudioStatus(callId: action.callUUID.uuidString, isEnabled: !action.isMuted)
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) { }
    
    // In order to properly manage the usage of AVAudioSession within CallKit, please implement this function as shown below.
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        SendBirdCall.audioSessionDidActivate(audioSession)
    }
    
    // In order to properly manage the usage of AVAudioSession within CallKit, please implement this function as shown below.
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
