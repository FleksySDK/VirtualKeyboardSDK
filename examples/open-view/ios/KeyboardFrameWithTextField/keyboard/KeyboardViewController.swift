//
//  KeyboardViewController.swift
//  keyboard
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
import FleksyKeyboardSDK

class KeyboardViewController: FKKeyboardViewController {
        
    override func createConfiguration() -> KeyboardConfiguration {
        // License Configuration
        let licenseConfig = LicenseConfiguration(licenseKey: "<your-license-key>", licenseSecret: "<your-license-secret>")
        
        // KEYBOARD CONFIGURATION --
        let config = KeyboardConfiguration(apps: AppsConfiguration(keyboardApps: [KeyboardFrameViewCustom.init()], showAppsInCarousel: false), /// This is a new parameter. We share the View that might be invoked.
                                           license: licenseConfig)
        return config
    }
    
    //
    // Trigger for opening the "App" that we have defined in this class KeyboardOpenView
    //
    override func triggerOpenApp() {
        self.openApp(appId: "someId.example")
    }
}
