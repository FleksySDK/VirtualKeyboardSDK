//
//  KeyboardViewController.swift
//  keyboard
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
import FleksyKeyboardSDK
import GiphyApp

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
        
        // CAPTURE DATA
        // Capturing by default
        // if we want to disable it, pass false instead
        let dataConfig = FLDataConfiguration(configFormat: .dataConfigFormat_groupByTap, accelerometer: true)
        let capture = CaptureConfiguration(true, output: enumCaptureOutput.captureOutput_string, dataConfig: dataConfig)
        
        // KEYBOARD STYLE
        let style = StyleConfiguration()
        
        // Appearance of press / long press
        let appPopup = AppearancePopup()
        let appLongpress = AppearanceLongPress()
        
        let appearance = AppearanceConfiguration(objPopup: appPopup, objTouch: nil, objLongpress: appLongpress)
        
        // TypingConfiguration which includes punctuationSymbols
        let typing = TypingConfiguration()
        
        // EmojiConfiguration at trigger point
        let emojiConfig = EmojiConfiguration(skinTone: enumEmojiSkinTone.emojiSkinTone_Neutral)
        
        // DebugConfiguration for get change layout
        let debugConfig = DebugConfiguration(debug: ())
      
        // Add specific height if you want -- here
        let panelConfig = PanelConfiguration()
        panelConfig.heightTopBar = 50
      
        let licenseConfig = LicenseConfiguration(licenseKey: "your-license-key", licenseSecret: "your-license-secret")
        
        let appsConfig = AppsConfiguration(keyboardApps: [GiphyApp(apiKey: "your-Giphy-api-key")],
                                           showAppsInCarousel: true)
        
        // KEYBOARD CONFIGURATION --
        // it groups capture, style and takes as constructor if we want a custom view or not + specific height
        //
        // this is going to be deprecated
        // let config = KeyboardConfiguration(customView: false, heightCustom: 46, capture: capture, style: style, appearance: appearance, typing:typing)
        
        let config = KeyboardConfiguration(panel: panelConfig,
                                           capture: capture,
                                           style: style,
                                           appearance: appearance,
                                           typing: typing,
                                           specialKeys: nil,
                                           apps: appsConfig,
                                           license: licenseConfig,
                                           debug: debugConfig)
        
        if #available(iOSApplicationExtension 11.0, *) {
            config.needsInputMethodSwitch = self.needsInputModeSwitchKey
        }
        config.emojiConfig = emojiConfig
        config.debugConfig = debugConfig
        
        return config
    }
    /// This is an expensive call - we should only enable it in test keyboards
    override func onLayoutChanges(_ dictLayout: [AnyHashable : Any]) {
    }
    
    override func dataCollection(_ data: String) {
        // TODO: Receive data.
    }
    
}
