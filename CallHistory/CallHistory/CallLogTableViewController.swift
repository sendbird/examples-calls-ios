//
//  CallLogTableViewController.swift
//  CallHistory
//
//  Created by Jaesung Lee on 2021/05/11.
//

import UIKit
import Commons
import SendBirdCalls

class CallLogTableViewController: UITableViewController {
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    
    var callLogs: [DirectCallLog] = []
    var query: DirectCallLogListQuery?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapAuthenticate() {
        guard let userId = userIdTextField.text?.collapsed else { return }
        
        if SendBirdCall.currentUser == nil {
            let authenticateParams = AuthenticateParams(userId: userId)
            SendBirdCall.authenticate(with: authenticateParams) { [self] (user, error) in
                guard let user = user, error == nil else { return }
                
                self.userIdTextField.isHidden = true
                self.authButton.setTitle("Sign Out", for: .normal)
                
                print("Successfully authenticated with userId: \(user.userId)")
                
                self.fetch()
            }
        } else {
            SendBirdCall.deauthenticate {[self] (error) in
                guard error == nil else { return }
                
                self.userIdTextField.isHidden = false
                self.authButton.setTitle("Sign In", for: .normal)
                
                print("Successfully deauthenticated from SendBirdCalls")
            }
        }
    }
    
    func fetch() {
        let param = DirectCallLogListQuery.Params()
        param.limit = 100
        param.myRole = .caller
        param.endResults = [.completed, .canceled, .declined, .noAnswer]
        
        query = SendBirdCall.createDirectCallLogListQuery(with: param)
        query?.next { [self] nextLogs, error in
            guard let newCallLogs = nextLogs else { return }
            callLogs.append(contentsOf: newCallLogs)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callLogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CallLogTableViewCell
        cell.callLog = callLogs[indexPath.row]
        return cell
    }
}

