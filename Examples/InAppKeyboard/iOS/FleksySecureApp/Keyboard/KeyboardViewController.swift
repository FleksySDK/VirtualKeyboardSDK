//
//  KeyboardViewController.swift
//  keyboard
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//

import UIKit
import FleksyKeyboardSDK


// MARK: - KeyboardViewController

class KeyboardViewController: FleksyKeyboardSDK.FKKeyboardViewController {
        
    private var theme = 0
    
    //
    // External Configuration based on preferences
    //
    func setConfiguration(themeSelection: Int){
        theme = themeSelection
    }
    
    override func createConfiguration() -> KeyboardConfiguration {
      // Configuration of the keyboard

        // KEYBOARD STYLE
        let style = KeyboardStyle().factoryStyle(styleSelection: theme)
        
        // TypingConfiguration which includes punctuationSymbols
        let typing = TypingConfiguration()
      
        //
        // Please, INPUT your own License and Secret key here:
        //
        let license = LicenseConfiguration(licenseKey: "your-license-key", licenseSecret: "your-license-secret")

        
        // KEYBOARD CONFIGURATION --
        // it groups capture, style and takes as constructor if we want a custom view or not + specific height
        let config = KeyboardConfiguration( style: style,
                                         typing: typing,
                                         license: license)
        return config
    }
    
    
    // COSMETICS
    
    // 1- Remove appIcon as might be not required
    override var appIcon: UIImage?{
        return nil
    }
}
