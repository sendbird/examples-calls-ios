//
//  CallingViewController.swift
//  ScreenRecordExample
//
//  Created by Minhyuk Kim on 2020/12/03.
//

import UIKit
import SendBirdCalls
import Photos
import Commons

class CallingViewController: UIViewController {
    
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
    }
    
    @IBAction
    func didTapEndCallButton(_ sender: Any) {
        call.end()
    }
}

extension CallingViewController: DirectCallDelegate {
    func didConnect(_ call: DirectCall) {
        print("Call connected")
    }
    
    func didEnd(_ call: DirectCall) {
        self.dismiss(animated: true) {
            print("Successfully finished")
        }
    }
}
