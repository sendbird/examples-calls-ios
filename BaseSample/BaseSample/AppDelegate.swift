//
//  AppDelegate.swift
//  BaseSample
//
//  Created by Minhyuk Kim on 2021/03/25.
//

import UIKit
import SendBirdCalls

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appId: String = "ADD6749c-9165-48e4-abeb-bf58f7c399df"// <#Application ID From Sendbird Dashboard#>
        SendBirdCall.configure(appId: appId)
        SendBirdCall.addDelegate(self, identifier: "AppDelegate")
        
        return true
    }
}

// Process incoming call
extension AppDelegate: SendBirdCallDelegate {
    func didStartRinging(_ call: DirectCall) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let callerId = call.caller?.userId,
                  let viewController = storyboard.instantiateViewController(withIdentifier: "CallingViewController") as? CallingViewController else { return }
            
            let alertController = UIAlertController(title: "Incoming Call",
                                                    message: "Incoming \(call.isVideoCall ? "Video" : "Audio") Call from \(callerId)",
                                                    preferredStyle: .alert)
            
            let acceptAction = UIAlertAction(title: "Accept", style: .default, handler: { (_) in
                call.accept(with: AcceptParams(callOptions: CallOptions(isAudioEnabled: true, isVideoEnabled: true)))
                viewController.call = call
                DispatchQueue.main.async {
                    alertController.dismiss(animated: true, completion: nil)
                    UIViewController.topViewController?.present(viewController, animated: true, completion: nil)
                }
            })
            let declineAction = UIAlertAction(title: "Decline", style: .destructive, handler: { (_) in
                call.end()
            })
            
            alertController.addAction(acceptAction)
            alertController.addAction(declineAction)
            
            UIViewController.topViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
