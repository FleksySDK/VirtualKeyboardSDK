//
//  CommonUtils.swift
//  FleksyCoreSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import Foundation

class Utils {
    
    static func getLanguageFileURL(for locale: String) -> URL? {
        let directory = getFolder(for: .languages)
        let fileName = "resourceArchive-\(locale).jet"
        
        if let directoryURL = directory,
           !FileManager.default.fileExists(atPath: directoryURL.path) {
            try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
        
        return directory?.appendingPathComponent(fileName, isDirectory: false)
    }

    static func getFolder(for folder: Constants.Folder) -> URL? {
        let documentsURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentsURL?.appendingPathComponent(folder.rawValue, isDirectory: true)
    }

    static func getBundleObject<T>(for key: String) -> T? {
        Bundle.main.object(forInfoDictionaryKey: key) as? T
    }

}
