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
}
