//
//  AppDelegate.swift
//  ScreenCaptureExample
//
//  Created by Minhyuk Kim on 2020/12/03.
//

import UIKit
import SendBirdCalls

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appId: String = <#Application ID From Sendbird Dashboard#>
        SendBirdCall.configure(appId: appId)
        
        return true
    }
}
