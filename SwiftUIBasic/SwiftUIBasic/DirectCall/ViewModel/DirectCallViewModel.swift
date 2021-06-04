//
//  DirectCallViewModel.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/06/14.
//

import Combine
import SendBirdCalls

class DirectCallViewModel: ObservableObject {
    enum CallState: String {
        case none = ""
        case onDialing = "dialing"
        case onRinging = "ringing"
        case onEstablished = "established"
        case onConnected = "connected"
        case onReconnecting = "reconnecting"
        case onReconnected = "reconnected"
    }
    
    @Published var calleeID: String = ""
    @Published var error: String = ""
    @Published var callState: CallState = .none
    
    var call: DirectCall?
    
    func dial() {
        let callOptions = CallOptions(
            isAudioEnabled: true,
            isVideoEnabled: false,
            localVideoView: nil,
            remoteVideoView: nil,
            useFrontCamera: true
        )
        
        let dialParams = DialParams(
            calleeId: calleeID,
            isVideoCall: false,
            callOptions: callOptions,
            customItems: [:]
        )
        // TODO: Convert to Combine
        SendBirdCall.dial(with: dialParams) { [self] (call, error) in
            call?.delegate = self
            self.call = call
            if let error = error {
                self.error = error.localizedDescription
            } else{
                callState = .onDialing
            }
        }
    }
    
    func accept() {
        let callOptions = CallOptions(
            isAudioEnabled: true,
            isVideoEnabled: false,
            localVideoView: nil,
            remoteVideoView: nil,
            useFrontCamera: true
        )
        let acceptParams = AcceptParams(callOptions: callOptions)
        
        call?.accept(with: acceptParams)
    }
    
    func end() {
        call?.end()
    }
}

extension DirectCallViewModel: DirectCallDelegate {
    func didConnect(_ call: DirectCall) {
        callState = .onConnected
    }
    
    func didEnd(_ call: DirectCall) {
        callState = .none
        self.call = nil
    }
}
