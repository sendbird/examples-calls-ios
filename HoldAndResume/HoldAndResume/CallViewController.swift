//
//  CallViewController.swift
//  MediaControl
//
//  Created by Jaesung Lee on 2021/05/17.
//

import UIKit
import SendBirdCalls
import Commons
import AVKit


class CallViewController: UIViewController {
    
    var call: DirectCall!
    
    @IBOutlet weak var localVideoView: UIView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet var holdStatusLabel: UILabel!
    @IBOutlet var holdButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CXCallManager.shared.delegate = self 
        
        let remoteView = SendBirdVideoView(frame: self.view.frame)
        view.embed(remoteView)
        let localView = SendBirdVideoView(frame: localVideoView.frame)
        localVideoView.embed(localView)
        
        call.updateRemoteVideoView(remoteView)
        call.updateLocalVideoView(localView)
        
        call.delegate = self
        
        call.startVideo()
    }
    
    @IBAction func didTapMic() {
        self.didChangeAudioStatus(callId: call.callId, isEnabled: !call.isLocalAudioEnabled)
        CXCallManager.shared.updateCall(call)
    }
    
    @IBAction func didTapVideo() {
        call.hold { error in
            
        }
        if call.isLocalVideoEnabled {
            call.stopVideo()
        } else {
            call.startVideo()
        }
        videoButton.setImage(
            UIImage(
                systemName: call.isLocalVideoEnabled
                    ? "video.slash.fill"
                    : "video.fill"
            ),
            for: .normal
        )
    }
    
    @IBAction func didTapEndCall() {
        call.end()
    }
    
    @IBAction func didTapHold(_ sender: UIButton) {
        sender.isEnabled = false
        if call.isOnHold {
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            call.unhold(force: shouldForce) { error in
                sender.isEnabled = true
                print("Removed a hold from a call with error: \(String(describing: error))")
            }
        } else {
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            call.hold { error in
                sender.isEnabled = true
                print("Put a call on hold with error: \(String(describing: error))")
            }
        }
    }
    
}

extension CallViewController: CXCallManagerDelegate {
    func didChangeAudioStatus(callId: String, isEnabled: Bool) {
        guard callId == self.call.callId else { return }
        
        if isEnabled {
            call.unmuteMicrophone()
        } else {
            call.muteMicrophone()
        }
        micButton.setImage(
            UIImage(
                systemName: call.isLocalAudioEnabled
                    ? "mic.slash.fill"
                    : "mic.fill"
            ),
            for: .normal
        )
    }
}
extension CallViewController: DirectCallDelegate {
    func didConnect(_ call: DirectCall) {
        CXCallManager.shared.connectedCall(call)
        print("Call Connected")
    }
    
    func didEnd(_ call: DirectCall) {
        print("Call Ended \(call.endResult.rawValue)")
        CXCallManager.shared.endCXCall(call)
        self.dismiss(animated: true)
    }
    
    func didRemoteAudioSettingsChange(_ call: DirectCall) {
        print("[Remote audio status has been changed] Current audio: \(call.isRemoteAudioEnabled ? "on" : "off")")
    }
    
    func didRemoteVideoSettingsChange(_ call: DirectCall) {
        print("[Remote video status has been changed] Current video: \(call.isRemoteVideoEnabled ? "on" : "off")")
    }
    
    func didUserHoldStatusChange(_ call: DirectCall, isLocalUser: Bool, isUserOnHold: Bool) {
        self.holdStatusLabel.isHidden = !call.isOnHold
        if isUserOnHold {
            self.holdStatusLabel.text = "The call is put on hold by \(isLocalUser ? "Local user" : "Remote user")"
        }
    }
}
