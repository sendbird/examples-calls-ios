//
//  SwiftUIAppState.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/06/14.
//

import Combine
import SendBirdCalls

class SwiftUIAppState: ObservableObject, SendBirdCallDelegate {
    @Published var onRinging: Bool = false
    
    var incomingCall: DirectCall? {
        didSet {
            onRinging = incomingCall != nil
        }
    }
    
    init() {
        SendBirdCall.addDelegate(self, identifier: "AppDelegate")
    }
    
    func didStartRinging(_ call: DirectCall) {
        incomingCall = call
    }
    
    func reset() {
        incomingCall = nil
    }
}
