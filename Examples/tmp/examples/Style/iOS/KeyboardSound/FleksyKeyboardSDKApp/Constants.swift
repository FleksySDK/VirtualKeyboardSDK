//
//  Constants.swift
//  FleksyKeyboardSDKApp
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import Foundation
import FleksyKeyboardSDK
import UIKit

enum Constants {
    enum App {
        static let keyboardExtensionBundleId = Bundle.main.bundleIdentifier! + ".keyboard"
        static var versionAndBuild: String {
            let buildConfigStr: String
            #if DEBUG
            buildConfigStr = "Dev "
            #else
            buildConfigStr = "Prod "
            #endif
            return buildConfigStr + versionAndBuild(forBundle: Bundle.main)
        }
        
        static var keyboardSDKVersionAndBuild: String {
            guard let bundle = Bundle(identifier: "co.thingthing.FleksyKeyboardSDK") else {
                return "-"
            }
            return versionAndBuild(forBundle: bundle)
        }
        
        private static func versionAndBuild(forBundle bundle: Bundle) -> String {
            let version = bundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let build = bundle.infoDictionary?["CFBundleVersion"] as? String ?? ""
            return "\(version) (\(build))"
        }
    }
    
    enum Images {
        static let check: UIImage? = {
            if #available(iOS 13, *) {
                return UIImage(systemName: "checkmark.circle")
            } else {
                return UIImage(named: "Check")
            }
        }()
        
        static let download: UIImage? = {
            if #available(iOS 13, *) {
                return UIImage(systemName: "square.and.arrow.down")
            } else {
                return UIImage(named: "Download")
            }
        }()
        
        static let plus: UIImage? = {
            if #available(iOS 13, *) {
                return UIImage(systemName: "plus.circle")
            } else {
                return UIImage(named: "Plus")
            }
        }()
        
        static let keyboard: UIImage? = {
            if #available(iOS 13, *) {
                return UIImage(systemName: "keyboard.fill")
            } else {
                return nil
            }
        }()
        
        static let trash: UIImage? = {
            if #available(iOS 13, *) {
                return UIImage(systemName: "trash")
            } else {
                return UIImage(named: "trash")
            }
        }()
        
        static let dismissKeyboard: UIImage? = {
            if #available(iOS 13, *) {
                if let image = UIImage(systemName: "keyboard.chevron.compact.down") {
                    return image
                }
            }
            return UIImage(named: "hide-keyboard")
        }()
    }
    
    enum Locales {
        
        static func languageName(forCode code: String) -> String {
            Locale.current.localizedString(forIdentifier: code) ?? code
        }
    }
    
    enum Accessibility {
        enum TabBarPrefix {
            static let settingsTab = "TabItem.Settings."
            static let testPlanTab = "TabItem.TestPlan."
        }
        
        enum SectionPrefix {
            static let sound = "Settings.Sound."
        }
        
        enum ComponentSuffix {
            static let switchControl = "Switch"
            static let button = "Button"
            static let view = "View"
            static let checkmark = "Checkmark"
            static let textField = "TextField"
            static let label = "Label"
            static let picker = "Picker"
        }
    }
    
    enum Settings {
        static let userDefaults: UserDefaults = {
            let groupIdentifier = getAppGroupIdentifier(bundle: .main)
            return UserDefaults(suiteName: groupIdentifier)!
        }()
        
        struct TypedSetting<T: UserDefaultsReady> {
            let key: String
            let `default`: T
            
            func get() -> T {
                let value = Settings.userDefaults.value(forKey:key)
                return T(defaultsValue: value) ?? self.default
            }
            
            func set(_ value: T) {
                let defaultsValue = value.valueForUserDefaults
                Settings.userDefaults.set(defaultsValue, forKey: key)
            }
        }
        
        static let spacebarStyle = TypedSetting<enumSpacebarStyle>(key: "SDK_SAMPLE_SETTINGS_SPACEBAR_STYLE", default: enumSpacebarStyle.spacebarStyle_Automatic)
                
        static let eventBasedDataCapture = TypedSetting<Bool>(key: "thingthing.FleksySDK.sample.eventBasedDataCapture", default: true) // Temporary
        
        /// The name of the asset image to use for the button on the left of the top bar.
        ///
        /// An empty string means no image (e.g., the default image used by the SDK).
        static let actionButtonIconName = TypedSetting<String>(key: "thingthing.FleksySDK.sample.actionButtonIconName", default: "")
        
        // Typing Configuration constants
        static let caseSensitive = TypedSetting<Bool>(key: "SDK_SAMPLE_SETTINGS_CASE_SENSITIVE_LAYOUT", default: true)
        static let smartPunctuation = TypedSetting<Bool>(key: "SDK_SAMPLE_SETTINGS_SMART_PUNCTUATION", default: true)
        static let autoCapitalization = TypedSetting<Bool>(key: "SDK_SAMPLE_SETTINGS_AUTO_CAPITALIZATION", default: true)
        static let autoLearn = TypedSetting<Bool>(key: "SDK_SAMPLE_SETTINGS_AUTO_LEARN", default: true)
        static let doubleSpaceAdsPeriod = TypedSetting<Bool>(key: "SDK_SAMPLE_SETTINGS_DOUBLE_SPACE_ADS_PERIOD", default: true)
        static let minimalMode = TypedSetting<Bool>(key: "SDK_SAMPLE_SETTINGS_MINIMAL_MODE", default: false)
        static let swipeTyping = TypedSetting<Bool>(key: "SDK_SAMPLE_SETTINGS_SWIPE_TYPING", default: true)
        static let swipeTriggerLength = TypedSetting<Int>(key: "SDK_SAMPLE_SETTINGS_SWIPE_TRIGGER_LENGTH", default: 30)
        static let swipeLeftToDelete = TypedSetting<Bool>(key: "SDK_SAMPLE_SETTINGS_SWIPE_LEFT_TO_DELETE", default: true)
        static let autocorrectAfterPunctuation = TypedSetting<Bool>(key: "SDK_SAMPLE_SETTINGS_AUTOCORRECT_AFTER_PUNCTUATION", default: true)
        static let japaneseKeitaiMode = TypedSetting<Bool>(key: "SDK_SAMPLE_SETTINGS_JAPANESE_KEITAI_ENABLED", default: true)
        static let japaneseKeitaiDelay = TypedSetting<TimeInterval>(key: "SDK_SAMPLE_SETTINGS_JAPANESE_KEITAI_DELAY", default: FLEKSY_DEFAULT_KEITAI_DELAY)
        static let spacebarMovesCursor = TypedSetting<Bool>(key: "SDK_SAMPLE_SETTINGS_LONG_PRESS_SPACEBAR_MOVE_CURSOR", default: true)
        
    }
}

protocol UserDefaultsReady {
    init?(defaultsValue: Any?)
    
    /// The value that gets stored in user defaults
    var valueForUserDefaults: Any { get }
}

/// Default implementation
extension UserDefaultsReady {
    init?(defaultsValue: Any?) {
        if let obj = defaultsValue as? Self {
            self = obj
        } else {
            return nil
        }
    }
    
    var valueForUserDefaults: Any { self }
}

extension Bool: UserDefaultsReady { }
extension String: UserDefaultsReady { }
extension Int: UserDefaultsReady { }
extension Double: UserDefaultsReady { }
extension enumSpacebarStyle: UserDefaultsReady {
    init?(defaultsValue: Any?) {
        guard let uint = defaultsValue as? UInt else {
            return nil
        }
        self.init(rawValue: uint)
    }
    
    var valueForUserDefaults: Any {
        rawValue
    }
}
