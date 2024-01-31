//
//  KeyboardViewController.swift
//  keyboard
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
import FleksyKeyboardSDK
import GiphyApp
import Combine

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
        // Examples on configuration at startup
        
        let licenseConfig = LicenseConfiguration(licenseKey: "your-license-key", licenseSecret: "your-license-secret")
        
        let appsConfig = AppsConfiguration(keyboardApps: [GiphyApp(apiKey: "your-Giphy-api-key")],
                                           showAppsInCarousel: true)
        
        //
        // Create the configuration for the keyboard
        //
        return KeyboardConfiguration(apps: appsConfig,
                                     license: licenseConfig)
    }
}
