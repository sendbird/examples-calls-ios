//
//  UserDefaults.swift
//  
//
//  Created by Minhyuk Kim on 2021/04/05.
//

import Foundation
public extension UserDefaults {
    var remotePushToken: Data? {
        get { UserDefaults.standard.value(forKey: "com.sendbird.examples.pushtoken") as? Data }
        set { UserDefaults.standard.set(newValue, forKey: "com.sendbird.examples.pushtoken") }
    }
    
    var voipPushToken: Data? {
        get { UserDefaults.standard.value(forKey: "com.sendbird.examples.voippushtoken") as? Data }
        set { UserDefaults.standard.set(newValue, forKey: "com.sendbird.examples.voippushtoken") }
    }
}
