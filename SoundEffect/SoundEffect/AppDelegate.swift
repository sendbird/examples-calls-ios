//
//  AppDelegate.swift
//  SoundEffect
//
//  Created by Jaesung Lee on 2021/05/07.
//

import UIKit
import Commons
import SendBirdCalls

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appId: String = <#Application ID From Sendbird Dashboard#>
        SendBirdCall.configure(appId: appId)
        SendBirdCall.addDelegate(self, identifier: "AppDelegate")
        
        registerRemoteNotifications(application)
        addDirectCallSounds()
        return true
    } 
    
    func registerRemoteNotifications(_ application: UIApplication) {
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

extension AppDelegate: SendBirdCallDelegate {
    func didStartRinging(_ call: DirectCall) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let callerId = call.caller?.userId,
                  let viewController = storyboard.instantiateViewController(withIdentifier: "CallViewController") as? CallViewController else { return }
            
            let alertController = UIAlertController(
                title: "Incoming Call",
                message: "Incoming audio call from \(callerId)",
                preferredStyle: .alert
            )
            
            // MARK: - Accept
            let callOptions = CallOptions(isAudioEnabled: true, isVideoEnabled: true)
            let acceptParams = AcceptParams(callOptions: callOptions)
            let acceptAction = UIAlertAction(title: "Accept", style: .default) { (_) in
                call.accept(with: acceptParams)
                viewController.ongoingCall = call
                DispatchQueue.main.async {
                    alertController.dismiss(animated: true, completion: nil)
                    UIViewController.topViewController?.present(viewController, animated: true, completion: nil)
                }
            }
            // MARK: - Decline
            let declineAction = UIAlertAction(title: "Decline", style: .destructive) { (_) in
                call.end()
            }
            
            alertController.addAction(acceptAction)
            alertController.addAction(declineAction)
            
            UIViewController.topViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}

