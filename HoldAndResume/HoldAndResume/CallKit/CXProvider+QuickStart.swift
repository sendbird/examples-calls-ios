//
//  CXProvider+QuickStart.swift
//  QuickStart
//
//  Copyright © 2020 Sendbird, Inc. All rights reserved.
//

import CallKit
import UIKit

extension CXProviderConfiguration {
    // The app's provider configuration, representing its CallKit capabilities
    static var `default`: CXProviderConfiguration {
        let providerConfiguration = CXProviderConfiguration(localizedName: "Sendbird Calls")
        if let image = UIImage(named: "icLogoSymbolInverse") {
            providerConfiguration.iconTemplateImageData = image.pngData()
        }
        
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.maximumCallGroups = 3
        providerConfiguration.supportedHandleTypes = [.generic]
        providerConfiguration.ringtoneSound = "Ringing.mp3"
        
        return providerConfiguration
    }
}

extension CXProvider {
    static var `default`: CXProvider {
        CXProvider(configuration: .`default`)
    }
}
