//
//  AppDelegate.swift
//  ScreenRecordExample
//
//  Created by Minhyuk Kim on 2020/12/03.
//

import UIKit
import SendBirdCalls
import Commons

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appId: String = "add6749c-9165-48e4-abeb-bf58f7c399df"//<#Application ID From Sendbird Dashboard#>
        SendBirdCall.configure(appId: appId)
        SendBirdCall.addDelegate(self, identifier: "AppDelegate")
        
        if let url = FileManager.recordingsDirectory {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return true
    }
}

// Process incoming call
extension AppDelegate: SendBirdCallDelegate {
    func didStartRinging(_ call: DirectCall) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let callerId = call.caller?.userId,
              let viewController = storyboard.instantiateViewController(withIdentifier: "CallingViewController") as? CallingViewController else { return }
        
        let alertController = UIAlertController(title: "Incoming Call",
                                           message: "Incoming \(call.isVideoCall ? "Video" : "Audio") Call from \(callerId)",
                                           preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default, handler: { (_) in
            call.accept(with: AcceptParams(callOptions: CallOptions(isAudioEnabled: true)))
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
        
        DispatchQueue.main.async {
            UIViewController.topViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
