//
//  UIViewController.swift
//  
//
//  Created by Minhyuk Kim on 2020/12/18.
//

import UIKit

extension UIViewController {
    public static var topViewController: UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}
    
