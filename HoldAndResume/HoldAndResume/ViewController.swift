//
//  ViewController.swift
//  LocalViewControl
//
//  Created by Minhyuk Kim on 2021/06/11.
//

import UIKit
import SendBirdCalls

var shouldForce = false
var holdActiveCalls = false

class ViewController: UIViewController {
    
    @IBOutlet weak var calleeIdTextField: UITextField!
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var authenticateButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let callVC = segue.destination as? CallViewController,
              let call = sender as? DirectCall else { return }
        
        callVC.call = call
    }
    
    @IBAction func statusSwitchChanged(_ sender: UISwitch) {
        if sender.tag == 0 {
            shouldForce = sender.isOn
        } else {
            holdActiveCalls = sender.isOn
        }
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) { }
    
    @IBAction func didTapAuthenticate() {
        guard let userId = userIdTextField.text?.collapsed else { return }
        
        if SendBirdCall.currentUser == nil {
            let authenticateParams = AuthenticateParams(userId: userId)
            SendBirdCall.authenticate(with: authenticateParams) { (user, error) in
                guard let user = user, error == nil else { return }
                
                SendBirdCall.registerVoIPPush(token: UserDefaults.standard.voipPushToken, completionHandler: nil)
                
                self.userIdTextField.isHidden = true
                self.authenticateButton.setTitle("Sign Out", for: .normal)
                
                print("Successfully authenticated with userId: \(user.userId)")
            }
        } else {
            SendBirdCall.deauthenticate { (error) in
                guard error == nil else { return }
                
                SendBirdCall.unregisterVoIPPush(token: UserDefaults.standard.voipPushToken, completionHandler: nil)
                
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
            customItems: [:],
            holdActiveCall: holdActiveCalls
        )
        
        if holdActiveCalls { // NOTE: Because a new CXCall will be established, we have to hold existing calls first in order to prevent them from being ended automatically.
            CXCallManager.shared.currentCalls.filter(\.isOnHold).forEach {
                CXCallManager.shared.setHoldCXCall($0.uuid, isHold: true)
            }
        }
        
        SendBirdCall.dial(with: dialParams) { (call, error) in
            guard let call = call, error == nil else { return }
            CXCallManager.shared.startCXCall(call) { success in
                print("Started a new CXCall with success: \(success)")
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "dial", sender: call)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
