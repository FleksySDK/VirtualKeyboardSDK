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
    
    let style: KeyboardStyle
    
    //
    // External Configuration based on preferences
    //
    init(style: KeyboardStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createConfiguration() -> KeyboardConfiguration {
        // Configuration of the keyboard
        
        // KEYBOARD STYLE
        let style = style.getStyleConfiguration()
        
        // TypingConfiguration which includes punctuationSymbols
        let typing = TypingConfiguration()
        
        //
        // Please, INPUT your own License and Secret key here:
        //
        let license = LicenseConfiguration(licenseKey: "your-license-key", licenseSecret: "your-license-secret")

        
        // KEYBOARD CONFIGURATION --
        // it groups capture, style and takes as constructor if we want a custom view or not + specific height
        let config = KeyboardConfiguration(style: style,
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
