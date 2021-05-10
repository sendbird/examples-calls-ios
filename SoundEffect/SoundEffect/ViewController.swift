//
//  ViewController.swift
//  SoundEffect
//
//  Created by Jaesung Lee on 2021/05/07.
//

import UIKit
import SendBirdCalls

class CallViewController: UIViewController {
    @IBOutlet weak var calleeIdTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var authenticateButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var callStatusLabel: UILabel!
    
    var ongoingCall: DirectCall?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        callStatusLabel.isHidden = true
    }
    
    @IBAction func didTapAuthenticate() {
        guard let userId = userIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if userId.isEmpty { return }
        
        let authParams = AuthenticateParams(userId: userId)
        
        SendBirdCall.authenticate(with: authParams) { [self] user, error in
            guard error == nil else { return }
            
            authenticateButton.isEnabled = false
        }
    }

    @IBAction func didTapCall() {
        if let currentCall = ongoingCall {
            end(currentCall)
        } else {
            dial()
        }
    }
    
    private func dial() {
        guard let calleeId = calleeIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if calleeId.isEmpty { return }
        
        let dialParams = DialParams(calleeId: calleeId)
        
        SendBirdCall.dial(with: dialParams) { [self] call, error in
            guard let call = call, error == nil else {
                callButton.backgroundColor = .init(#colorLiteral(red: 0.509719789, green: 0.3168306947, blue: 0.9718012214, alpha: 1))
                return
            }
            
            call.delegate = self
            ongoingCall = call
            
        }
        callButton.backgroundColor = .red
        callStatusLabel.isHidden = false
        callStatusLabel.text = "waiting..."
    }
    
    private func end(_ call: DirectCall) {
        call.end()
        callButton.backgroundColor = .init(#colorLiteral(red: 0.509719789, green: 0.3168306947, blue: 0.9718012214, alpha: 1))
        callStatusLabel.isHidden = true
        ongoingCall = nil
    }
}

extension CallViewController: DirectCallDelegate {
    // TODO: Update specific cell for the direct call.
    func didEstablish(_ call: DirectCall) {
        callStatusLabel.text = "connecting..."
    }
    
    func didConnect(_ call: DirectCall) {
        callStatusLabel.text = "connected"
    }
    
    func didStartReconnecting(_ call: DirectCall) {
        callStatusLabel.text = "reconnecting..."
    }
    
    func didReconnect(_ call: DirectCall) {
        callStatusLabel.text = "reconnected"
    }
    
    func didEnd(_ call: DirectCall) {
        call.delegate = nil
    }
}
