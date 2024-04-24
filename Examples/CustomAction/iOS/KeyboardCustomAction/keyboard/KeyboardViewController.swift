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
        // Examples on configuration at startup
                
        let licenseConfig = LicenseConfiguration(licenseKey: "your-license-key", licenseSecret: "your-license-secret")
        
        
        //
        // Example: CustomLayoutConfiguration
        //
        // Add Custom Action button with an AspectFill example image and a simple print action
        //
        let actionButton = CustomizationBundleConfiguration.Button(label: "custom-action",
                                                            image: UIImage(named: "IconOrange"),
                                                            contentMode: .scaleAspectFill,
                                                            action: { _ in
            // Do something for "custom-action" pressed
            print("> Pressed custom-action")
        })
        let customActionConfig = CustomizationBundleConfiguration(bundleFileName: "custom-action", buttons: [actionButton])
        
        
        //
        // Create the configuration for the keyboard
        //
        return KeyboardConfiguration(customizationBundle: customActionConfig,
                                           license: licenseConfig)
    }
    

    override var appIcon: UIImage?{
        return UIImage(named: "IconBlue")
    }
    
    override func triggerOpenApp() {
        print("> Pressed appIcon")
    }
    
}
