//  ExampleLanguageViewModel.swift
//  LanguagesExample
//
//  Created on 12/4/24
//
//

import FleksySDK
import SwiftUI

@MainActor class ExampleLanguageViewModel: ObservableObject {
    
    static let exampleLocale = "es-ES" // You can change this constant to test other languages.
    
    @Published var keyboardStatus: (installed: Bool, fullAccess: Bool) = (false, false)
    
    @Published var status: LanguageDownloadStatus
    @Published var enabledLanguages: [KeyboardLanguage] = []
    
    @Published var loadingLayoutOptions: Bool = false
    @Published var layoutOptionsForExampleLocale: [String] = []
    @Published var selectedLayout: String?
    
    var isExampleLocaleEnabled: Bool {
        enabledLanguages.contains(where: { keyboardLanguage in
            keyboardLanguage.locale == Self.exampleLocale
        })
    }
    
    var presentDownloadErrorAlert: Binding<Bool> {
        Binding(get: {
            switch self.status {
            case .downloaded, .notDownloaded, .downloading:
                return false
            case .downloadError, .languageNotAvailable:
                return true
            }
        }, set: {
            self.status = $0 ? .downloadError : .notDownloaded
        })
    }
    
    init() {
        self.status = ExampleLanguageViewModel.isExampleLanguageDownloaded ? .downloaded : .notDownloaded
        reloadLanguagesInfo()
    }
    
    enum LanguageDownloadStatus {
        case downloaded
        case notDownloaded
        case downloading(progress: Float)
        case downloadError
        case languageNotAvailable
        
        var isDownloadError: Bool {
            if case .downloadError = self {
                return true
            } else {
                return false
            }
        }
    }
    
    // MARK: - Interface
    
    func onDownloadExampleLanguage() {
        let localeToDownload = Self.exampleLocale
        
        self.status = .downloading(progress: 0)
        /// Firstly, we check all available languages in the repository.
        LanguagesHelper.availableLanguages { (languages: [String : LanguageResourceFiles]?) in
            guard let languages, !languages.isEmpty else {
                DispatchQueue.main.async {
                    self.status = .downloadError
                }
                return
            }
            guard languages.keys.contains(localeToDownload)  else {
                DispatchQueue.main.async {
                    self.status = .languageNotAvailable
                }
                return
            }
            
            /// Then, if the requested language is available, the language download request starts.
            LanguagesHelper.downloadLanguage(localeToDownload,
                                             onProgress: { bytesCurrent, bytesTotal in
                DispatchQueue.main.async {
                    let progress = bytesCurrent / bytesTotal
                    self.status = .downloading(progress: progress)
                }
            },
                                             onComplete: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.status = .downloaded
                        self.reloadLanguagesInfo()
                    case .failure:
                        self.status = .downloadError
                    }
                }
            })
        }
    }
    
    func onDeleteExampleLanguage() {
        if let _ = LanguagesHelper.deleteLanguage(Self.exampleLocale) {
            self.status = .notDownloaded
        } else {
            print("Could not delete language \(Self.exampleLocale)")
        }
        reloadLanguagesInfo()
    }
    
    func onAddExampleLanguage() {
        /// If the language is not downloaded, calling `addLanguage` is only useful if `automaticDownload`
        /// is set to `true` in `LanguageConfiguration` (see `KeyboardViewController.swift`.
        /// Otherwise, the language won't be available in the keyboard until it is downloaded.
        LanguagesHelper.addLanguage(KeyboardLanguage(locale: Self.exampleLocale))
        reloadLanguagesInfo()
    }
    
    func onChangeLayoutForExampleLanguage(newLayout: String) {
        /// This method does not add the language to the keyboard.
        /// It only changes the preferred layout for the language.
        LanguagesHelper.updateLanguageLayout(KeyboardLanguage(locale: Self.exampleLocale, layout: newLayout))
        reloadLanguagesInfo()
    }
    
    func onFetchLayoutOptionsForExampleLanguage() {
        self.loadingLayoutOptions = true
        
        /// This method returns all the information for a language file that is available locally.
        /// If the language in not available locally, you must download it before calling this method.
        LanguagesHelper.languageResourceDetails(Self.exampleLocale) { (languageResource: LanguageResource?) in
            DispatchQueue.main.async {
                self.loadingLayoutOptions = false
                self.layoutOptionsForExampleLocale = languageResource?.layouts ?? []
                self.reloadLanguagesInfo()
            }
        }
    }
    
    func onSelectLayout(_ layout: String) {
        /// This method changes the preferred layout for any language, regardless of whether the language
        /// is available locally or not.
        LanguagesHelper.updateLanguageLayout(KeyboardLanguage(locale: Self.exampleLocale, layout: layout))
        
        reloadLanguagesInfo()
    }
    
    func refreshKeyboardState() {
        let kbInstalled = FleksyExtensionSetupStatus.isAddedToSettingsKeyboardExtension(withBundleId: Bundle.main.bundleIdentifier! + ".keyboard")
        let kbHasFullAccess = UIInputViewController().hasFullAccess
        self.keyboardStatus = (kbInstalled, kbHasFullAccess)
    }
    
    // MARK: - Private methods
    
    private static var isExampleLanguageDownloaded: Bool {
        /// This method returns all locally available languages.
        let downloadedLanguages = LanguagesHelper.storedLocales()
        
        return downloadedLanguages.contains(exampleLocale)
    }
    
    private func reloadLanguagesInfo() {
        /// `FleksyManagedSettings.userLanguages` contains the enabled locales in the keyboard.
        /// Important: for the keyboard to be able to use those languages, they need to be available locally
        /// (you can synchronously check the downloaded languages with `LanguagesHelper.storedLocales()`).
        self.enabledLanguages = FleksyManagedSettings.userLanguages
        
        /// To get the preferred layout of the passed language.
        self.selectedLayout = LanguagesHelper.getCurrentLayoutForLanguage(Self.exampleLocale)
    }
}
