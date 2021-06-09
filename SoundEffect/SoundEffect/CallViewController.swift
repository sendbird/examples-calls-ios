//
//  CallViewController.swift
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
    @IBOutlet weak var callStatusLabel: UILabel!
    
    var ongoingCall: DirectCall?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        callStatusLabel.isHidden = true
    }
    
    @IBAction func didTapAuthenticate() {
        guard let userId = userIdTextField.text?.collapsed else { return }
        
        if SendBirdCall.currentUser == nil {
            let authenticateParams = AuthenticateParams(userId: userId)
            SendBirdCall.authenticate(with: authenticateParams) { (user, error) in
                guard let user = user, error == nil else { return }
                
                self.userIdTextField.isHidden = true
                self.authenticateButton.setTitle("Sign Out", for: .normal)
                
                print("Successfully authenticated with userId: \(user.userId)")
            }
        } else {
            SendBirdCall.deauthenticate { (error) in
                guard error == nil else { return }
                
                self.userIdTextField.isHidden = false
                self.authenticateButton.setTitle("Sign In", for: .normal)
                
                print("Successfully deauthenticated from SendBirdCalls")
            }
        }
    }

    @IBAction func didTapDialButton() {
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
            guard let call = call, error == nil else { return }
            
            call.delegate = self
            ongoingCall = call
            
        }
        callStatusLabel.isHidden = false
        callStatusLabel.text = "waiting..."
    }
    
    private func end(_ call: DirectCall) {
        call.end()
        callStatusLabel.isHidden = true
        ongoingCall = nil
    }
}

extension CallViewController: DirectCallDelegate {
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
