//
//  KeyboardViewController.swift
//  keyboard
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
import FleksyKeyboardSDK
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
        let licenseConfig = LicenseConfiguration(licenseKey: "your-license-key",
                                                 licenseSecret: "your-license-secret")
        return KeyboardConfiguration(license: licenseConfig)
    }
    
    //
    // EventBus Usage
    //
    
    // Subscribe to the events that we want
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToEvents()
    }
    
    // UnSubscribe to the events that we want
    //
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        observations.removeAll()
    }
    
    private var observations: Set<AnyCancellable> = []
    
    private func subscribeToEvents(){
        eventBus.activity.sink { activityEvent in
            print("Activity event: \(activityEvent)")
            
            // Important! All eventBus events come from a background thread, if you want to make UI changes, use the main thread.
            //
        }
        .store(in: &observations)
        
        eventBus.configuration.sink { configurationEvent in
            print("Configuration event: \(configurationEvent)")
        }.store(in: &observations)
    }
}
