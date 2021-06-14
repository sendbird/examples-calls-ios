//
//  CallViewController.swift
//  AutoAnswer
//
//  Created by Minhyuk Kim on 2021/06/11.
//

import UIKit
import SendBirdCalls
import Commons

class CallViewController: UIViewController {
    
    var call: DirectCall!
    
    @IBOutlet weak var localVideoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remoteView = SendBirdVideoView(frame: self.view.frame)
        view.embed(remoteView)
        let localView = SendBirdVideoView(frame: localVideoView.frame)
        localVideoView.embed(localView)
        
        call.updateRemoteVideoView(remoteView)
        call.updateLocalVideoView(localView)
        
        call.delegate = self
        
        call.startVideo()
    }
    
    @IBAction func didTapEndCall() {
        call.end()
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
