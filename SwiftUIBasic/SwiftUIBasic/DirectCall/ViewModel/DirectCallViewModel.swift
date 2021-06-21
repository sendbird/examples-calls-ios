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
    @Published var callState: CallState = .none
    
    var call: DirectCall?
    
    func dial() {
        /// 1. create `CallOptions` object
        let callOptions = CallOptions(
            isAudioEnabled: true,
            isVideoEnabled: false,
            localVideoView: nil,
            remoteVideoView: nil,
            useFrontCamera: true
        )
        
        /// 2. create `DialParams` object.
        let dialParams = DialParams(
            calleeId: calleeID,
            isVideoCall: false,
            callOptions: callOptions,
            customItems: [:]
        )
        /// 3. dial with `DialParams`
        SendBirdCall.dial(with: dialParams) { [self] (call, error) in
            /// 4. error handling
            guard let call = call else {
                print(error?.localizedDescription ?? "unknown error")
            }
            /// 5. set `DirectCallDelegate`
            call.delegate = self
            /// 6. set `self.call`
            self.call = call
            /// 7. update call state
            callState = .onDialing
        }
    }
    
    func accept() {
        /// 1. create `CallOptions` object
        let callOptions = CallOptions(
            isAudioEnabled: true,
            isVideoEnabled: false,
            localVideoView: nil,
            remoteVideoView: nil,
            useFrontCamera: true
        )
        /// 2. create `AcceptParams` with call options
        let acceptParams = AcceptParams(callOptions: callOptions)
        
        /// 3. accept incoming call with accept params
        call?.accept(with: acceptParams)
    }
    
    func end() {
        /// 1. end call
        call?.end()
    }
}

/// To update call state
extension DirectCallViewModel: DirectCallDelegate {
    func didConnect(_ call: DirectCall) {
        callState = .onConnected
    }
    
    func didEnd(_ call: DirectCall) {
        callState = .none
        /// set `self.call` as nil
        self.call = nil
    }
}
