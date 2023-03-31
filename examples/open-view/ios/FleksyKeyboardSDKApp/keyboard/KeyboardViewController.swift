//
//  KeyboardViewController.swift
//  keyboard
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
import FleksyKeyboardSDK

// MARK: - KeyboardViewController

class KeyboardViewController: FKKeyboardViewController {
    
    // MARK: View Controller life cycle
    
    /// - Important: Every time the keyboard appears it calls in this order: ``viewDidLoad`` -> ``viewWillAppear`` -> ``viewDidAppear``.
    /// Keyboard extensions don't reuse the view, which means that, in every appearance, we recreate what's inside ``viewDidLoad``.
    /// This behaviour is different from the normal iOS ViewController.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func createConfiguration() -> KeyboardConfiguration {
                
        // KEYBOARD STYLE
        let style = StyleConfiguration()
      
        // License Configuration
        let licenseConfig = LicenseConfiguration(licenseKey: "your-license-key", licenseSecret: "your-license-secret")
        
        // KEYBOARD CONFIGURATION --
        let config = KeyboardConfiguration( style: style,
                                           specialKeys: nil,
                                            apps: AppsConfiguration(keyboardApps: [KeyboardOpenView.init()], showAppsInCarousel: false), /// This is a new parameter. We share the View that might be invoked.
                                           license: licenseConfig)
        
        if #available(iOSApplicationExtension 11.0, *) {
            config.needsInputMethodSwitch = self.needsInputModeSwitchKey
        }
        return config
    }
    
    //
    // Trigger for opening the "App" that we have defined in this class KeyboardOpenView
    //
    override func triggerOpenApp() {
        self.openApp(appId: "someId.example")
    }
}
