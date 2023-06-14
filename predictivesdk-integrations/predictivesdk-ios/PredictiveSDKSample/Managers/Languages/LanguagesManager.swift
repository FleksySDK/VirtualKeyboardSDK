//
//  LanguagesManager.swift
//  PredictiveSDKSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import Foundation
import PredictiveSDK
import Combine

class LanguagesManager {
    
    private static let enLanguageLocale = "en-US"
    private static let bundledLanguageURL = Bundle.main.url(forResource: "resourceArchive-en-US", withExtension: "jet")!
    
    static var shared = LanguagesManager()
    
    private(set) var latestLanguageFileURL = LanguagesManager.getLanguageFileURL()
    
    /// A publisher that notifies that a new file is available in ``latestLanguageFileURL``.
    ///
    /// Note that even though the ``latestLanguageFileURL`` might be unchanged, when this event is sent, it means that the file at that url has changed.
    var languageFileUpdatePublisher: AnyPublisher<Void, Never> {
        languageFileUpdateSubject.eraseToAnyPublisher()
    }
    private var languageFileUpdateSubject = PassthroughSubject<Void, Never>()
    
    private var localLanguage: LocalLanguage? {
        return LanguagesHelper.getMetadataFromLanguageFile(at: latestLanguageFileURL)
    }
    
    var localeVersion: String? {
        return self.localLanguage.map {
            "Language \($0.locale) v\($0.version)"
        }
    }
    
    private static func getLanguageFileURL() -> URL {
        if let languageURL = Utils.getLanguageFileURL(for: self.enLanguageLocale),
           FileManager.default.fileExists(atPath: languageURL.path) {
            return languageURL
        } else {
            return self.bundledLanguageURL
        }
    }
    
    func load() {
        Task {
            if await self.needsToDownloadLanguage() {
                if await self.downloadLanguage(locale: Self.enLanguageLocale) {
                    self.latestLanguageFileURL = Self.getLanguageFileURL()
                    languageFileUpdateSubject.send()
                }
            }
        }
    }
    
    /// Calling this method removes the language at ``latestLanguageFileURL``, so that next time the language file can be redownloaded.
    ///
    /// This does nothing if the ``latestLanguageFileURL`` refers to the bundled language file because it can't be deleted by the `FileManager`.
    func onInvalidLanguageFile() {
        if FileManager.default.fileExists(atPath: self.latestLanguageFileURL.path) {
            do {
            try FileManager.default.removeItem(at: self.latestLanguageFileURL)
                self.latestLanguageFileURL = Self.getLanguageFileURL()
                self.languageFileUpdateSubject.send()
            } catch {
                NSLog("LanguageManager: could not invalid language file: %@", error.localizedDescription)
            }
        }
    }
    
    private func needsToDownloadLanguage() async -> Bool {
        guard let localLanguage = self.localLanguage else {
            return true
        }
        let languagesResult = await LanguagesHelper.availableLanguages()
        switch languagesResult {
        case .failure(let error):
            NSLog("LanguageManager: Could not fetch available languages: \(error.localizedDescription)")
            return false
        case .success(let languages):
            guard let remoteLanguage = languages.filter({ $0.locale == localLanguage.locale }).first else {
                NSLog("LanguageManager: Could not find remote language file with locale \(localLanguage.locale)")
                return false
            }
            guard self.isCurrentVersionLower(than: remoteLanguage) else {
                NSLog("LanguageManager: Local language file already up to date")
                return false
            }
            return true
        }
    }
    
    private func downloadLanguage(locale: String) async -> Bool {
        guard let languageURL = Utils.getLanguageFileURL(for: Self.enLanguageLocale) else {
            return false
        }
                
        for await status in LanguagesHelper.downloadLanguageFile(locale: locale, fileURL: languageURL) {
            switch status {
            case .downloading(bytesCurrent: let current, bytesTotal: let total):
                NSLog("Downloading \(locale) file: %.02f%", 100.0 * current / total)
            case .finished(let result):
                switch result {
                case .success:
                    NSLog("LanguageManager: Successfully downloaded language \(locale)")
                    return true
                case .failure(let error):
                    NSLog("LanguageManager: Error during language \(locale) download: \(error.localizedDescription)")
                    return false
                }
            @unknown default:
                return false
            }
        }
        return false
    }
    
    private func isCurrentVersionLower(than remoteLanguage: RemoteLanguage) -> Bool {
        guard var currentVersion = self.localLanguage?.version.getLanguageVersion() else { return false }
        
        var remoteVersion = remoteLanguage.version.getLanguageVersion()
        guard currentVersion != remoteVersion else { return false }
        
        let maxVersionComponents = max(currentVersion.count, remoteVersion.count)
        currentVersion += Array(repeating: 0, count: maxVersionComponents - currentVersion.count)
        remoteVersion += Array(repeating: 0, count: maxVersionComponents - remoteVersion.count)
        
        var isLower = false
        for (current, remote) in zip(currentVersion, remoteVersion) {
            guard current != remote else { continue }
            isLower = current < remote
            break
        }
        return isLower
    }
}

fileprivate extension String {
    func getLanguageVersion() -> [Int] {
        components(separatedBy: ".").compactMap(Int.init)
    }
}
