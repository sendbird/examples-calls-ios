//
//  ViewController.swift
//  MediaControl
//
//  Created by Jaesung Lee on 2021/05/17.
//

import UIKit
import SendBirdCalls

class ViewController: UIViewController {
    
    @IBOutlet weak var calleeIdTextField: UITextField!
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var authenticateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let callVC = segue.destination as? CallViewController,
              let call = sender as? DirectCall else { return }
        
        callVC.call = call
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
    
    @IBAction func didTapDialButton(_ sender: Any) {
        guard let calleeId = calleeIdTextField.text?.collapsed else { return }
        let callOptions = CallOptions(isAudioEnabled: true)
        let dialParams = DialParams(
            calleeId: calleeId,
            isVideoCall: true,
            callOptions: callOptions,
            customItems: [:]
        )
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
}

