//  CommonUtils.swift
//  FleksyKeyboardSDKApp
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//


import Foundation

// MARK: - App Group
func getAppGroupIdentifier(bundle: Bundle = .main) -> String {
    if let appGroupName = bundle.object(forInfoDictionaryKey: "AppGroupName") as? String {
        return appGroupName
    } else {
        return ""
    }
}

func getGroupSharedFolder(bundle: Bundle) -> URL? {
    let groupIdentifier = getAppGroupIdentifier(bundle: bundle)
    return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
}
