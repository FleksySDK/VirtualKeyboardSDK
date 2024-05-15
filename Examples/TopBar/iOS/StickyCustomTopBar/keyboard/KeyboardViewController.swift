//
//  KeyboardViewController.swift
//  keyboard
//
//  Copyright © 2024 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
import FleksyKeyboardSDK

class KeyboardViewController: FKKeyboardViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        openApp(appId: KeyboardFrameViewCustom.appId) 
    }
    
    override func createConfiguration() -> KeyboardConfiguration {
        // License Configuration
        let licenseConfig = LicenseConfiguration(licenseKey: "<your-license-key>", licenseSecret: "<your-license-secret>")
        
        // Apps Configuration
        let appsConfig = AppsConfiguration(keyboardApps: [KeyboardFrameViewCustom()],
                                           showAppsInCarousel: false) // Since we open the Keyboard app programmatically, we don't want the app carousel
        
        // KEYBOARD CONFIGURATION --
        return KeyboardConfiguration(apps: appsConfig,
                                     license: licenseConfig)
    }
    
    /// To hide the magnifying glass icon.
    /// Since we open the Keyboard app programmatically, we don't want the app carousel
    override var appIcon: UIImage? {
        return nil
    }
}
