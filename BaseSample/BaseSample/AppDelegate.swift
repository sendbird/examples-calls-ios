//
//  AppDelegate.swift
//  BaseSample
//
//  Created by Minhyuk Kim on 2021/03/25.
//

import UIKit
import Commons
import UserNotifications
import SendBirdCalls

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appId: String = <#Application ID From Sendbird Dashboard#>
        SendBirdCall.configure(appId: appId)
        SendBirdCall.addDelegate(self, identifier: "AppDelegate")
        
        remoteNotificationsRegistration(application)
        return true
    }
    
    func remoteNotificationsRegistration(_ application: UIApplication) {
        application.registerForRemoteNotifications()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            guard error == nil else {
                print("Error while requesting permission for notifications.")
                return
            }
            
            // If success is true, the permission is given and notifications will be delivered.
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.standard.remotePushToken = deviceToken
        SendBirdCall.registerRemotePush(token: deviceToken, completionHandler: nil)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SendBirdCall.application(application, didReceiveRemoteNotification: userInfo)
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
