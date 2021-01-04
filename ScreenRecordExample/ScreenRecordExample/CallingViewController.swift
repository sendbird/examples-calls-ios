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
    var recordingId: String?
    
    @IBOutlet weak var localVideoView: UIView!
    
    @IBOutlet weak var remoteRecordingIndicatorView: UIView!
    @IBOutlet weak var recordingIndicatorView: UIView!
    
    @IBOutlet weak var recordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let remoteView = SendBirdVideoView(frame: self.view.frame)
        view.embed(remoteView)
        let localView = SendBirdVideoView(frame: localVideoView.frame)
        localVideoView.embed(localView)
        
        call.updateRemoteVideoView(remoteView)
        call.updateLocalVideoView(localView)
        
        call.delegate = self
        SendBirdCall.addRecordingDelegate(self, identifier: "Recording Delegate")

        call.startVideo()
    }
    
    deinit {
        SendBirdCall.removeRecordingDelegate(identifier: "Recording Delegate")
    }
    
    @IBAction func didTapRecordingButton(_ sender: Any) {
        if call.localRecordingStatus == .recording, let recordingId = self.recordingId {
            // Stop recording
            call.stopRecording(recordingId: recordingId)
            self.recordingIndicatorView.isHidden = true
            self.recordingButton.setTitle("Start Recording", for: .normal)
        } else {
            // Start recording
            let controller = UIAlertController(title: "Record Call", message: "Choose Option", preferredStyle: .actionSheet)
            
            let remoteAudioVideoAction = UIAlertAction(title: "Remote Audio / Video", style: .default) { _ in
                self.startRecording(with: .remoteAudioAndVideo)
            }
            
            let localAudioVideoAction = UIAlertAction(title: "Local Audio / Video", style: .default) { _ in
                self.startRecording(with: .localAudioAndVideoRemoteAudio)
            }
            
            controller.addAction(remoteAudioVideoAction)
            controller.addAction(localAudioVideoAction)
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func startRecording(with recordingType: RecordingOptions.RecordingType) {
        guard let url = FileManager.recordingsDirectory else { return }
        
        let recordingOptions = RecordingOptions(recordingType: recordingType, directoryPath: url)
        call.startRecording(options: recordingOptions) { recordingId, error in
            print("Started recording with recordingId: \(String(describing: recordingId)) and error: \(String(describing: error))")
            
            self.recordingId = recordingId
            self.recordingIndicatorView.isHidden = false
            self.recordingButton.setTitle("Stop Recording", for: .normal)
        }
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

extension CallingViewController: SendBirdRecordingDelegate {
    func didRemoteRecordingStatusChange(_ call: DirectCall) {
        let isRecording = call.remoteRecordingStatus == .recording
        self.remoteRecordingIndicatorView.isHidden = !isRecording
    }
    
    func didSaveRecording(call: DirectCall, recordingId: String, options: RecordingOptions, outputURL: URL) {
        print("Successfully saved recording")
    }
    
    func didFailToSaveRecording(call: DirectCall, recordingId: String, error: SBCError) {
        print("Failed to save recording")
    }
}
