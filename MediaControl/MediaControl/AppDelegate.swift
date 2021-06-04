//
//  AppDelegate.swift
//  MediaControl
//
//  Created by Jaesung Lee on 2021/05/17.
//

import UIKit
import SendBirdCalls
import Commons

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

// MARK: - Process incoming calls
extension AppDelegate: SendBirdCallDelegate {
    func didStartRinging(_ call: DirectCall) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let callerId = call.caller?.userId,
              let callVC = storyboard.instantiateViewController(withIdentifier: "CallViewController") as? CallViewController
        else { return }
        
        let alertController = UIAlertController(
            title: "Incoming Call",
            message: "Incoming \(call.isVideoCall ? "Video" : "Audio") Call from \(callerId)",
            preferredStyle: .alert
        )
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { _ in
            let callOptions = CallOptions(isAudioEnabled: true)
            let acceptParams = AcceptParams(callOptions: callOptions)
            call.accept(with: acceptParams)
            callVC.call = call
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion: nil)
                UIViewController.topViewController?.present(
                    callVC,
                    animated: true,
                    completion: nil
                )
            }
        }
        
        let declineAction = UIAlertAction(title: "Decline", style: .destructive) { _ in
            call.end()
        }
        
        alertController.addAction(acceptAction)
        alertController.addAction(declineAction)
        
        DispatchQueue.main.async {
            UIViewController.topViewController?.present(
                alertController,
                animated: true,
                completion: nil
            )
        }
    }
}
