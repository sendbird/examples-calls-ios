//
//  ViewController.swift
//  AutoAnswer
//
//  Created by Minhyuk Kim on 2021/06/11.
//

import UIKit
import SendBirdCalls

class ViewController: UIViewController {
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var authenticateButton: UIButton!
    
    @IBAction func didAnswerOptionChange(_ sender: UISegmentedControl) {
        AnswerOptions.option = .init(rawValue: sender.selectedSegmentIndex)!
    }
    
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
                
                SendBirdCall.registerRemotePush(token: UserDefaults.standard.remotePushToken, completionHandler: nil)
                
                self.userIdTextField.isHidden = true
                self.authenticateButton.setTitle("Sign Out", for: .normal)
                
                print("Successfully authenticated with userId: \(user.userId)")
            }
        } else {
            SendBirdCall.deauthenticate { (error) in
                guard error == nil else { return }

                SendBirdCall.unregisterRemotePush(token: UserDefaults.standard.remotePushToken, completionHandler: nil)
                
                self.userIdTextField.isHidden = false
                self.authenticateButton.setTitle("Sign In", for: .normal)
                
                print("Successfully deauthenticated from SendBirdCalls")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

