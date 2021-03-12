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
        
        call.startVideo()
    }
    
    @IBAction func didTapCaptureLocalButton(_ sender: Any) {
        call.captureLocalVideoView { (image, error) in
            guard let image = image, error == nil else {
                print("Failed to capture local image")
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveError(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @IBAction
    func didTapCaptureRemoteButton(_ sender: Any) {
        call.captureRemoteVideoView { (image, error) in
            guard let image = image, error == nil else {
                print("Failed to capture remote image")
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveError(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc
    func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Finished saving image to photos library with error: \(String(describing: error))")
    }
    
    
    @IBAction
    func didTapEndCallButton(_ sender: Any) {
        call.end()
    }
}

extension CallingViewController: DirectCallDelegate {
    func didConnect(_ call: DirectCall) {
        print("Call Connected")
    }
    
    func didEnd(_ call: DirectCall) {
        print("Call Ended")
        self.dismiss(animated: true)
    }
}
