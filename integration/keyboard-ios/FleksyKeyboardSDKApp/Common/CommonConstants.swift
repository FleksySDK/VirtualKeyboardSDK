//
//  CommonConstants.swift
//  FleksyKeyboardSDKApp
//
//  Copyright © 2021 Thingthing,Ltd. All rights reserved.
//

import Foundation

enum Constants {
    enum Accessibility {
        
        static let welcomeScreenPrefix = "WelcomeScreen."
        static let keyboardAccessibilityID = "FleksyKeyboardSDK.identifier"
        
        enum SectionPrefix {
            static let setupFleksyKeyboard = "Settings.SetupKeyboard."
            static let keyboardTest = "Settings.KeyboardTest."
            static let languages = "Settings.Languages."
            static let look = "Settings.Look."
            static let gestures = "Settings.Gestures."
            static let typing = "Settings.Typing."
            static let sound = "Settings.Sound."
            static let appVersion = "Settings.AppVersion."
            static let keyboardSDKVersion = "Settings.KeyboardSDKVersion."
            static let engineVersion = "Settings.EngineVersion."
            static let licenseChange = "Settings.LicenseChange"
        }
        
        enum ActionPrefix {
            static let delete = "Delete."
            static let reorder = "Reorder."
            static let dismissKeyboard = "DismissKeyboard."
        }
        
        enum ItemPrefix {
            static let keyboardInfo = "KeyboardInfo."
        }
        
        enum ComponentSuffix {
            static let switchControl = "Switch"
            static let button = "Button"
            static let view = "View"
            static let checkmark = "Checkmark"
            static let textField = "TextField"
            static let label = "Label"
        }
        
        enum Languages {
            enum Prefix {
                static let keyboardLayout = "KeyboardLayout."
                static let download = "Download."
                static let downloading = "Downloading."
                static let setCurrent = "SetCurrent."
                static let currentLanguage = "CurrentLanguage."
            }
        }
        
        enum License {
            enum Prefix {
                static let activationStatus = "ActivationStatus."
                static let capabilities = "Capabilities."
                static let licenseKey = "LicenseKey."
                static let licenseSecret = "LicenseSecret."
            }
            
            enum ActionPrefix {
                static let resetKeys = "ResetKeys."
                static let validateKeys = "ValidateKeys."
            }
        }
    }
}
