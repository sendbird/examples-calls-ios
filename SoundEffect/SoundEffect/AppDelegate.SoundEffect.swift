//
//  AppDelegate.SoundEffect.swift
//  SoundEffect
//
//  Created by Jaesung Lee on 2021/05/07.
//

import Foundation
import SendBirdCalls

extension AppDelegate {
    func addDirectCallSounds() {
        /// Plays the sound even when the device is on silent mode.
        SendBirdCall.setDirectCallDialingSoundOnWhenSilentMode(isEnabled: true)
        
        /// Sets up sound effects for direct call.
        SendBirdCall.addDirectCallSound("Ringing.mp3", forType: .ringing)
        SendBirdCall.addDirectCallSound("Dialing.mp3", forType: .dialing)
        SendBirdCall.addDirectCallSound("ConnectionLost.mp3", forType: .reconnecting)
        SendBirdCall.addDirectCallSound("ConnectionRestored.mp3", forType: .reconnected)
    }
}
