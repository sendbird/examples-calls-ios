//
//  AppDelegate.swift
//  QuickStart
//
//  Copyright © 2020 Sendbird, Inc. All rights reserved.
//

import UIKit
import CallKit
import PushKit
import SendBirdCalls

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var voipRegistry: PKPushRegistry?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appId: String = <#Application Id#>
        SendBirdCall.configure(appId: appId)
        SendBirdCall.addDelegate(self, identifier: "AppDelegate")
        
        self.voipRegistration()
        
        return true
    }
}
