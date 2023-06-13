//
//  CommonConstants.swift
//  PredictiveSDKSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import Foundation

enum Constants {
    
    enum Folder: String {
        case languages = "Languages"
    }
    
    enum Images {
        enum System {
            static let exclamationMarkCircleFill = "exclamationmark.circle.fill"
        }
    }
    
    enum ErrorMessages {
        enum PredictiveServiceManager {
            static let invalidLicense = "License is invalid"
            static let invalidLanguage = "Language file did not load correctly"
            static let unknown = "Something went wrong"
            static let languageFileNotFound = "Language file not found"
        }
    }
}
