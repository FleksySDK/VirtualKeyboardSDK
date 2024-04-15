//  KeyboardViewController.swift
//  InAppKeyboardSwiftUI
//
//  Copyright © 2024 Thingthing,Ltd. All rights reserved.
//

import UIKit
import FleksySDK

/// Even to have the in-app keyboard in SwiftUI, you still need to create your
/// own subclass of FleksySDK's `FKKeyboardViewController`.
class KeyboardViewController: FKKeyboardViewController {
 
    override func createConfiguration() -> KeyboardConfiguration {
        //
        // Please, use your own License and Secret key here:
        //
        let license = LicenseConfiguration(licenseKey: "your-license-key", licenseSecret: "your-license-secret")
        
        return KeyboardConfiguration(license: license)
    }
    
    // COSMETICS
    
    // Remove appIcon as it might not be required
    override var appIcon: UIImage?{
        return nil
    }
}
