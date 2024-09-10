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
        /// Make sure to use a license that contains the `FKKeyboardLicenseCapability.health` capability.
        let licenseConfig = LicenseConfiguration(licenseKey: "your-license-key",
                                                 licenseSecret: "your-license-secret")
        
        /// Only enable those parts of the Events data capture that you are interested in
        let dataCaptureConfig = EventDataConfiguration(keyStroke: true,
                                                       delete: true,
                                                       keyPlane: true,
                                                       word: true,
                                                       swipe: true,
                                                       sessionUpdate: true,
                                                       stressMonitor: true)
        return KeyboardConfiguration(dataCapture: .eventBased(configuration: dataCaptureConfig),
                                     license: licenseConfig)
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
        eventBus.dataCapture.sink { dataCaptureEvent in
            switch dataCaptureEvent {
            case .keyStroke(let keyStroke):
                print("KeyStroke event: \(keyStroke)")
            case .delete(let delete):
                print("Delete event: \(delete)")
            case .keyPlane(let keyPlane):
                print("KeyPlane event: \(keyPlane)")
            case .word(let word):
                print("Word event: \(word)")
            case .swipe(let swipe):
                print("Swipe event: \(swipe)")
            case .sessionUpdate(let sessionUpdate):
                print("SessionUpdate event: \(sessionUpdate)")
            case .stressUpdate(let stressUpdate):
                print("StressUpdate event: \(stressUpdate)")
            @unknown default:
                print("Unknown event: \(dataCaptureEvent)")
            }
            
            // Important! All eventBus events come from a background thread, if you want to make UI changes, use the main thread.
            //
        }
        .store(in: &observations)
    }
}
