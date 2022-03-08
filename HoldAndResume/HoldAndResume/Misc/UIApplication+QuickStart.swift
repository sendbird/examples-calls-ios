//
//  UIApplication+QuickStart.swift
//  QuickStart
//
//  Created by Jaesung Lee on 2020/04/13.
//  Copyright © 2020 Sendbird Inc. All rights reserved.
//

import UIKit
import SendBirdCalls

extension UIApplication {
    func showCallController(with call: DirectCall, on viewController: UIViewController? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let callViewController = storyboard.instantiateViewController(withIdentifier: "CallViewController") as? CallViewController else { return }
            
            callViewController.call = call
            
            if let viewController = viewController ?? UIViewController.topViewController {
                viewController.present(callViewController, animated: true, completion: nil)
            } else {
                self.keyWindow?.rootViewController = viewController
                self.keyWindow?.makeKeyAndVisible()
            }
        }
    }
}
