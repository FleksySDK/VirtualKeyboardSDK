//
//  LanguagesManager.swift
//  FleksyKeyboardSDKApp
//
//  Copyright © 2021 Thingthing,Ltd. All rights reserved.
//

import Foundation
import FleksyKeyboardSDK

protocol LanguagesManagerDelegate: AnyObject {
    func didFinishDownloadingLanguage(_ language: LanguageModel)
    func didFailDownloadingLanguage(_ language: LanguageModel)
}

protocol LanguageModelDelegate: AnyObject {
    func downloadStateDidChange(_ language: LanguageModel)
}

class LanguageModel: Hashable {
    enum DownloadState {
        case notDownloaded
        case downloading(progress: Float)
        case downloaded
        case installed(currentLanguage: Bool, keyboardLayout: String?)
    }
    let code: String
    var languageName: String? {
        Constants.Locales.languageName(forCode: code)
    }
    weak var delegate: LanguageModelDelegate?
    
    fileprivate(set) var downloadState: DownloadState {
        didSet {
            delegate?.downloadStateDidChange(self)
        }
    }
    
    var isCurrentLanguage: Bool {
        if case .installed(currentLanguage: true, keyboardLayout: _) = downloadState {
            return true
        } else {
            return false
        }
    }
    
    var accessibilityPrefix: String {
        Constants.Accessibility.SectionPrefix.languages + code + "."
    }
    
    static func == (lhs: LanguageModel, rhs: LanguageModel) -> Bool {
        return lhs.code == rhs.code
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    
    fileprivate init(code: String, state: DownloadState) {
        self.code = code
        self.downloadState = state
    }
}


class LanguagesManager {
    static let shared = LanguagesManager()
    
    weak var delegate: LanguagesManagerDelegate?
    
    var currentLanguage: LanguageModel? {
        return installedLanguages.first {
            $0.code == SettingsSDK.userDefaults.string(forKey: FLEKSY_SETTINGS_LANGUAGE_PACK_KEY)
        }
    }
    
    private(set) var nonInstalledLanguages = [LanguageModel]()
    private(set) lazy var installedLanguages = [LanguageModel]()
    
    private var activeDownloads: [String : LanguageModel] = [:]
    
    private var availableLanguages: [String : LanguageResourceFiles]?
    private var languageResources: [String : LanguageResource] = [:]
    
    var availableLanguagesLoaded: Bool {
        availableLanguages?.isEmpty == false
    }
    
    // MARK: - Public API
    
    func loadAvailableLanguages(_ completion: @escaping () -> Void) {
        LanguagesHelper.availableLanguages { [weak self] availableLanguages in
            self?.reloadLanguageResources { [weak self] in
                self?.availableLanguages = availableLanguages
                self?.reloadLanguages()
                completion()
            }
        }
    }
    
    /// Downloads and installs the language.
    func downloadLanguage(_ language: LanguageModel) {
        downloadLanguage(language) { [weak self] in
            self?.delegate?.didFinishDownloadingLanguage(language)
        } onFailure: { [weak self] in
            self?.delegate?.didFailDownloadingLanguage(language)
        }
    }
    
    func setCurrentLanguage(_ language: LanguageModel) -> Bool {
        switch language.downloadState {
        case .downloaded, .installed(currentLanguage: false, keyboardLayout: _):
            self.installLanguage(language)
            if let index = nonInstalledLanguages.firstIndex(of: language) {
                nonInstalledLanguages.remove(at: index)
                installedLanguages.append(language)
            }
            if let previousLanguage = installedLanguages.first(where: { $0.isCurrentLanguage }) {
                previousLanguage.downloadState = .installed(currentLanguage: false, keyboardLayout: getCurrentLayout(forLanguage: previousLanguage.code))
            }
            language.downloadState = .installed(currentLanguage: true, keyboardLayout: getCurrentLayout(forLanguage: language.code))
            return true
        case .downloading, .installed(currentLanguage: true, keyboardLayout: _), .notDownloaded:
            return false
        }
    }
    
    func deleteLanguage(_ language: LanguageModel) -> Bool {
        guard canDeleteLanguage(language) else {
            return false
        }
        let success = LanguagesHelper.deleteLanguage(language.code) != nil
        if success {
            reloadLanguages()
        }
        return success
    }
    
    func canDeleteLanguage(_ language: LanguageModel) -> Bool {
        switch language.downloadState {
        case .downloaded, .installed(currentLanguage: false, keyboardLayout: _):
            return true
        case .notDownloaded, .downloading, .installed(currentLanguage: true, keyboardLayout: _):
            return false
        }
    }
    
    // MARK: Layouts
    
    func getCurrentLayout(forLanguage language: String) -> String? {
        LanguagesHelper.getCurrentLayoutForLanguage(language)
    }
    
    func getAvailableLayoutsForLanguage(_ language: String) -> [String] {
        languageResources[language]?.layouts ?? []
    }
    
    func setCurrentLayout(_ layout: String, for language: String) {
        let keyboardLanguage = KeyboardLanguage(locale: language, layout: layout)
        LanguagesHelper.updateLanguageLayout(keyboardLanguage)
        
        if let languageModel = installedLanguages.first(where: { $0.code == language }),
           case .installed(let currentLanguage, _) = languageModel.downloadState
        {
            languageModel.downloadState = .installed(currentLanguage: currentLanguage, keyboardLayout: layout)
        }
    }
    
    // MARK: - Register for notifications
    
    func registerForSetCurrentLanguageNotification() {
    }
    
    // MARK: - Private methods
    
    private func reloadLanguages() {
        let languagesOrder = SettingsSDK.userDefaults.object(forKey: FLEKSY_SETTINGS_LANGUAGE_INSTALLED_ORDER) as? [String] ?? []
        let storedLanguages = LanguagesHelper.storedLocales()
        
        let currentLanguage = SettingsSDK.userDefaults.object(forKey: FLEKSY_SETTINGS_LANGUAGE_PACK_KEY) as? String
        
        installedLanguages = languagesOrder
            .filter {
                storedLanguages.contains($0)
            }.map {
                LanguageModel(code: $0, state: .installed(currentLanguage: currentLanguage == $0, keyboardLayout: getCurrentLayout(forLanguage: $0)))
            }
        
        let installedLanguagesCodes = Set(installedLanguages.map { $0.code })
        
        nonInstalledLanguages = ((availableLanguages ?? [:]).keys + Array(storedLanguages))
            .filter {
                !installedLanguagesCodes.contains($0)
            }.sorted(by: <)
            .map {
                if let downloadingLanguage = self.activeDownloads[$0] {
                    return downloadingLanguage
                } else {
                    return LanguageModel(code: $0, state: storedLanguages.contains($0) ? .downloaded : .notDownloaded)
                }
            }
    }
    
    private func reloadLanguageResources(_ completion: @escaping () -> Void) {
        LanguagesHelper.availableResources { [weak self] in
            self?.languageResources = $0 ?? [:]
            completion()
        }
    }
    
    private func installLanguage(_ language: LanguageModel) {
        LanguagesHelper.addLanguage(KeyboardLanguage(locale: language.code))
    }
    
    private func downloadLanguage(_ language: LanguageModel, onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        guard case .notDownloaded = language.downloadState else {
            onFailure()
            return
        }
        language.downloadState = .downloading(progress: 0)
        activeDownloads[language.code] = language
        LanguagesHelper.downloadLanguage(language.code) { bytesCurrent, bytesTotal in
            DispatchQueue.main.async {
                language.downloadState = .downloading(progress: bytesCurrent / bytesTotal)
            }
        } onComplete: { [weak self] result in
            DispatchQueue.main.async {
                self?.reloadLanguageResources { [weak self] in
                    switch result {
                    case .failure:
                        language.downloadState = .notDownloaded
                        onFailure()
                    case .success:
                        self?.installLanguage(language)
                        language.downloadState = .installed(currentLanguage: false, keyboardLayout: self?.getCurrentLayout(forLanguage: language.code))
                        if let index = self?.nonInstalledLanguages.firstIndex(of: language) {
                            self?.nonInstalledLanguages.remove(at: index)
                        }
                        self?.installedLanguages.append(language)
                        onSuccess()
                    }
                    self?.activeDownloads[language.code] = nil
                }
            }
        }
    }
    
}
