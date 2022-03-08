//
//  CallListTableViewController.swift
//  CallKitHold
//
//  Created by Minhyuk Kim on 2021/06/17.
//  Copyright © 2021 SendBird Inc. All rights reserved.
//

import UIKit
import SendBirdCalls
class CallListTableViewController: UITableViewController {
    var ongoingCalls: [DirectCall] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.ongoingCalls = SendBirdCall.getOngoingCalls()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCallsChangedNotification(notification:)),
            name: CXCallManager.CallsChangedNotification,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ongoingCalls = SendBirdCall.getOngoingCalls()
    }
    
    @objc
    func handleCallsChangedNotification(notification: NSNotification) {
        tableView.reloadData()
    }
    
    @IBAction func showCurrentCall(_ sender: Any) {
        guard let index = CXCallManager.shared.currentCalls.firstIndex(where: { !$0.isOnHold }) else {
            print("All Calls are currently on hold.")
            return
        }
        
        let presentingVC = self.presentingViewController
        self.dismiss(animated: true) {
            UIApplication.shared.showCallController(with: CXCallManager.shared.currentDirectCalls[index], on: presentingVC)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ongoingCalls.count > 0 ? ongoingCalls.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard ongoingCalls.count > 0 else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No ongoing calls"
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "call", for: indexPath)
        
        cell.textLabel?.text = ongoingCalls[indexPath.row].remoteUser?.userId
        cell.detailTextLabel?.text = ongoingCalls[indexPath.row].isOnHold ? "On Hold" : "In Progress"
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard ongoingCalls.count > indexPath.row else { return }
        
        let directCall = ongoingCalls[indexPath.row]
        guard let call = CXCallManager.shared.currentCalls.first(where: { $0.uuid.uuidString == directCall.callId }) else { return }
        
        if call.isOnHold {
            let presentingVC = self.presentingViewController
            self.dismiss(animated: true) {
                UIApplication.shared.showCallController(with: directCall, on: presentingVC)
            }
        }
        
        CXCallManager.shared.setHoldCXCall(call.uuid, isHold: !call.isOnHold)
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}
