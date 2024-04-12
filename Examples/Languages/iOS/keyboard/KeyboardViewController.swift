//  KeyboardViewController.swift
//  keyboard
//
//  Created on 12/4/24
//  
//

import UIKit
import FleksySDK

class KeyboardViewController: FKKeyboardViewController {
    
    override func createConfiguration() -> KeyboardConfiguration {
        // -- License Configuration --
        let licenseConfig = LicenseConfiguration(licenseKey: "<your-license-key>",
                                                 licenseSecret: "<your-license-secret>")
        
        // -- Languages Configuration --
        /// We disable the `automaticDownload` in order to showcase how the
        /// language downloads from the Example app.
        let languageConfig = LanguageConfiguration(automaticDownload: false)
                
        return KeyboardConfiguration(language: languageConfig,
                                     license: licenseConfig)
    }
}
