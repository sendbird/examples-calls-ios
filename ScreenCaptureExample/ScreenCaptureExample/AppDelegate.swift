//
//  AppDelegate.swift
//  ScreenCaptureExample
//
//  Created by Minhyuk Kim on 2020/12/03.
//

import UIKit
import SendBirdCalls
import UserNotifications
import Commons

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appId: String = <#Application ID From Sendbird Dashboard#>
        SendBirdCall.configure(appId: appId)
        SendBirdCall.addDelegate(self, identifier: "AppDelegate")
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.standard.setValue(deviceToken, forKey: "PushToken")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SendBirdCall.application(application, didReceiveRemoteNotification: userInfo)
        completionHandler(.newData)
    }
}

extension AppDelegate: SendBirdCallDelegate {
    func didStartRinging(_ call: DirectCall) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let callerId = call.caller?.userId,
              let viewController = storyboard.instantiateViewController(withIdentifier: "CallingViewController") as? CallingViewController else { return }
        
        let controller = UIAlertController(title: "Incoming Call",
                                           message: "Incoming \(call.isVideoCall ? "Video" : "Audio") Call from \(callerId)",
                                           preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (_) in
            call.accept(with: AcceptParams(callOptions: CallOptions(isAudioEnabled: true)))
            viewController.call = call
            DispatchQueue.main.async {
                controller.dismiss(animated: true, completion: nil)
                UIViewController.topViewController?.present(viewController, animated: true, completion: nil)
            }
        }))
        
        controller.addAction(UIAlertAction(title: "Decline", style: .destructive, handler: { (_) in
            call.end()
        }))
        
        DispatchQueue.main.async {
            UIViewController.topViewController?.present(controller, animated: true, completion: nil)
        }
    }
}
