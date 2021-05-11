//
//  AppDelegate.swift
//  CallHistory
//
//  Created by Jaesung Lee on 2021/05/11.
//

import UIKit

import SendBirdCalls

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appId: String = <#Application ID From Sendbird Dashboard#>

        SendBirdCall.configure(appId: appId)
        
        return true
    }
}
