//
//  AppDelegate.swift
//  AutoAnswer
//
//  Created by Minhyuk Kim on 2021/06/11.
//

import UIKit
import SendBirdCalls
import Commons

@main
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

// MARK: - Process incoming calls
extension AppDelegate: SendBirdCallDelegate {
    func didStartRinging(_ call: DirectCall) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let callerId = call.caller?.userId,
                  let callVC = storyboard.instantiateViewController(withIdentifier: "CallViewController") as? CallViewController
            else { return }
            
            func acceptCall() {
                let callOptions = CallOptions(isAudioEnabled: true)
                let acceptParams = AcceptParams(callOptions: callOptions)
                call.accept(with: acceptParams)
                callVC.call = call
                UIViewController.topViewController?.present(
                    callVC,
                    animated: true,
                    completion: nil
                )
            }
            
            func declineCall() {
                call.end()
            }
            
            switch AnswerOptions.option {
            case .accept:
                acceptCall()
                let alert = UIAlertController(title: "Call automatically accepted", message: nil, preferredStyle: .actionSheet)
                UIViewController.topViewController?.present(
                    alert,
                    animated: true,
                    completion: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                )
            case .decline:
                declineCall()
                let alert = UIAlertController(title: "Call automatically declined", message: nil, preferredStyle: .actionSheet)
                UIViewController.topViewController?.present(alert, animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
            case .wait:
                let alertController = UIAlertController(
                    title: "Incoming Call",
                    message: "Incoming \(call.isVideoCall ? "Video" : "Audio") Call from \(callerId)",
                    preferredStyle: .alert
                )
                
                alertController.addAction(UIAlertAction(title: "Accept", style: .default) { _ in
                    alertController.dismiss(animated: true, completion: nil)
                    acceptCall()
                })
                alertController.addAction(UIAlertAction(title: "Decline", style: .destructive) { _ in
                    declineCall()
                })
                
                UIViewController.topViewController?.present(
                    alertController,
                    animated: true,
                    completion: nil
                )
            }
        }
    }
}
