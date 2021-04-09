//
//  CallingViewController.swift
//  ScreenRecordExample
//
//  Created by Minhyuk Kim on 2020/12/03.
//

import UIKit
import SendBirdCalls
import ReplayKit

var recentCallId: String = ""

class CallingViewController: UIViewController {
    
    var call: DirectCall!
    var recordingId: String?
    
    @IBOutlet weak var localVideoView: UIView!
    
    @IBOutlet weak var screenShareButton: UIButton!
    let rpScreenRecorder = RPScreenRecorder.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let remoteView = SendBirdVideoView(frame: self.view.frame)
        view.embed(remoteView)
        let localView = SendBirdVideoView(frame: localVideoView.frame)
        localVideoView.embed(localView)
        
        call.updateRemoteVideoView(remoteView)
        call.updateLocalVideoView(localView)
        
        self.screenShareButton.setTitle(call.isLocalScreenShareEnabled ? "Stop Share" : "Start Share", for: .normal)
        call.delegate = self
        call.startVideo()
    }
    
    @IBAction func didTapScreenShareButton(_ sender: Any) {
        if call.isLocalScreenShareEnabled == false {
            self.call.startScreenShare { (bufferHandler, error) in
                self.rpScreenRecorder.startCapture { (buffer, type, error) in
                    bufferHandler?(buffer, error)
                } completionHandler: { (error) in
                    guard error == nil else {
                        self.call.stopScreenShare()
                        return
                    }
                    
                    self.screenShareButton.setTitle("Stop Share", for: .normal)
                    print("Successfully started screen share")
                }
            }
        } else {
            self.rpScreenRecorder.stopCapture { error in
                guard error == nil else { return } // Handle error
                
                self.call.stopScreenShare { error in
                    self.screenShareButton.setTitle("Start Share", for: .normal)
                    
                    print("Stopped screen share with error: \(String(describing: (error)))")
                }
            }
        }
    }
    
    @IBAction func didTapDismissButton(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Dismissing CallingViewController")
        }
    }
    
    @IBAction
    func didTapEndCallButton(_ sender: Any) {
        call.end()
    }
}

extension CallingViewController: DirectCallDelegate {
    func didConnect(_ call: DirectCall) {
        recentCallId = call.callId
        print("Call connected")
    }
    
    func didEnd(_ call: DirectCall) {
        self.dismiss(animated: true) {
            print("Successfully finished")
        }
    }
}
