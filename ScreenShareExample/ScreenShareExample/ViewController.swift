//
//  ViewController.swift
//  ScreenShareExample
//
//  Created by Minhyuk Kim on 2021/03/12.
//

import UIKit
import SendBirdCalls
import Commons

class ViewController: UIViewController {

    @IBOutlet weak var calleeIdTextField: UITextField!
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var authenticateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.authenticateButton.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? CallingViewController,
              let call = sender as? DirectCall else { return }

        destination.call = call
    }

    @IBAction func didTapDialButton(_ sender: Any) {
        guard let calleeId = calleeIdTextField.text?.collapsed else { return }
        
        let dialParams = DialParams(calleeId: calleeId, isVideoCall: true, callOptions: CallOptions(isAudioEnabled: true), customItems: [:])
        SendBirdCall.dial(with: dialParams) { (call, error) in
            guard let call = call, error == nil else { return }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "dial", sender: call)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc
    func authenticate() {
        guard let userId = userIdTextField.text?.collapsed else { return }
        
        let authenticateParams = AuthenticateParams(userId: userId)
        SendBirdCall.authenticate(with: authenticateParams) { (user, error) in
            guard let user = user, error == nil else { return }
            
            self.authenticateButton.setTitle("Sign Out", for: .normal)
            self.userIdTextField.isHidden = true
            self.authenticateButton.removeTarget(self, action: #selector(self.authenticate), for: .touchUpInside)
            self.authenticateButton.addTarget(self, action: #selector(self.deauthenticate), for: .touchUpInside)
            print("Successfully authenticated with userId: \(user.userId)")
        }
    }
    
    @objc
    func deauthenticate() {
        SendBirdCall.deauthenticate { (error) in
            guard error == nil else { return }
            
            self.authenticateButton.setTitle("Sign In", for: .normal)
            self.userIdTextField.isHidden = false
            self.authenticateButton.removeTarget(self, action: #selector(self.deauthenticate), for: .touchUpInside)
            self.authenticateButton.addTarget(self, action: #selector(self.authenticate), for: .touchUpInside)
            print("Successfully deauthenticated from SendBirdCalls")
        }
    }
    
    @IBAction func didTapReturnToCallButton(_ sender: Any) {
        guard SendBirdCall.getOngoingCallCount() == 1,
              let call = SendBirdCall.getCall(forCallId: recentCallId) else {
            print("No ongoing call")
            return
        }
        
        self.performSegue(withIdentifier: "dial", sender: call)
    }
}

