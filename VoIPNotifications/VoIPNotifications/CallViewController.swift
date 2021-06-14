//
//  CallViewController.swift
//  MediaControl
//
//  Created by Jaesung Lee on 2021/05/17.
//

import UIKit
import SendBirdCalls
import Commons

class CallViewController: UIViewController {
    
    var call: DirectCall!
    
    @IBOutlet weak var localVideoView: UIView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    
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
        print("Call Connected")
    }
    
    func didEnd(_ call: DirectCall) {
        print("Call Ended")
        self.dismiss(animated: true)
    }
    
    func didRemoteAudioSettingsChange(_ call: DirectCall) {
        print("[Remote audio status has been changed] Current audio: \(call.isRemoteAudioEnabled ? "on" : "off")")
    }
    
    func didRemoteVideoSettingsChange(_ call: DirectCall) {
        print("[Remote video status has been changed] Current video: \(call.isRemoteVideoEnabled ? "on" : "off")")
    }
}
