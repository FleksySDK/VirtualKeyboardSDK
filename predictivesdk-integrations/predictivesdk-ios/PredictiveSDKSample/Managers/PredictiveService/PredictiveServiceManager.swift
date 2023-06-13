//
//  PredictiveServiceManager.swift
//  PredictiveSDKSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import Foundation
import Combine
import PredictiveSDK

class PredictiveServiceManager {
    
    enum FleksyError: Error {
        case invalidLicense
        case invalidURL
        case languageFileNotFound
        case unknown
    }
    
    static let shared = PredictiveServiceManager()
    
    var candidatePublisher: AnyPublisher<Result<[Candidate], FleksyError>, Never> {
        candidateSubject
            .map { (result: Result<[Candidate], PredictiveService.Error>) -> Result<[Candidate], FleksyError> in
                result.map { candidates in
                    candidates.sorted {
                        $0.score > $1.score
                    }
                }.mapError { (error) -> FleksyError in
                    switch error {
                    case .licenseNotValid:
                        return .invalidLicense
                    default:
                        return .unknown
                    }
                }
            }
            .eraseToAnyPublisher()
        
    }
    private var candidateSubject = CurrentValueSubject<Result<[Candidate], PredictiveService.Error>, Never>(.success([]))
    
    var localeLanguageVersionNamePublisher: AnyPublisher<String?, Never> {
        localeLanguageVersionNameSubject.eraseToAnyPublisher()
    }
    private var localeLanguageVersionNameSubject = CurrentValueSubject<String?, Never>(nil)
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private var predictiveService: PredictiveService? {
        try? predictiveServiceResult.get()
    }
    private let predictiveServiceResult: Result<PredictiveService, FleksyError>
    
    init() {
        self.predictiveServiceResult = PredictiveServiceManager.createPredictiveService(languageFileURL: LanguagesManager.shared.latestLanguageFileURL)
        self.localeLanguageVersionNameSubject.value = LanguagesManager.shared.localeVersion
        
        self.configurePredictiveService()
        self.subscribeToLanguageFileChanges()
    }
    
    // MARK: - Public interface
    
    func currentWordPrediction(_ text: String, start: UInt, end: UInt) {
        guard let predictiveService else {
            return
        }

        Task.detached(priority: .userInitiated) {
            let context = TypingContext(context: text, cursorStart: start, cursorEnd: end)
            let result = await predictiveService.currentWordPrediction(context)
            self.candidateSubject.send(result)
        }
    }
    
    func nextWordPrediction(_ text: String, start: UInt, end: UInt) {
        guard let predictiveService else {
            return
        }

        Task.detached(priority: .userInitiated) {
            let context = TypingContext(context: text, cursorStart: start, cursorEnd: end)
            let result = await predictiveService.nextWordPrediction(context)
            self.candidateSubject.send(result)
        }
    }
    
    // MARK: - (Private) License and configuration
    
    private static func createPredictiveService(languageFileURL: URL) -> Result<PredictiveService, FleksyError> {
        do {
            let predictiveService = try PredictiveService(languageFileURL: languageFileURL, configuration: Self.getLibraryConfig())
            return .success(predictiveService)
        } catch PredictiveService.Error.invalidFileURL {
            return .failure(.invalidURL)
        } catch {
            return .failure(.unknown)
        }
    }
    
    private static func getLibraryConfig() -> LibraryConfiguration {
        return LibraryConfiguration(license: self.getLicense(), language: .init(layout: .embedded(name: "QWERTY")))
    }
    
    private static func getLicense() -> LicenseConfiguration {
        let licenseKey: String = Utils.getBundleObject(for: "SDKLicenseKey") ?? ""
        let licenseSecret: String = Utils.getBundleObject(for: "SDKLicenseSecret") ?? ""

        return LicenseConfiguration(licenseKey: licenseKey, licenseSecret: licenseSecret)
    }
    
    private func configurePredictiveService() {
        /// These words are added as extra dictionary words and will be considered for autocorrection.
        self.predictiveService?.addWordsToDictionary([
            "rolf", "henllo", "huggies", "removeExample",
            // Names
            "Eustaquio", "Eustace", "Alonso", "Umurçan", "Hadiya",
            // Places
            "Sevilla", "Málaga", "Andalucía",
            // Food
            "habas", "lentejas", "sopa",
        ])
        
        /// These words are removed from the extra dictionary words and will not be considered for autocorrection
        self.predictiveService?.removeWordsFromDictionary([
            "removeExample"
        ])
        
        /// All the words added by the first call will be considered for autocorrection except for "removeExample", because it was removed from the dictionary in the second call.
        ///
        /// Note that `removeWordsFromDictionary` only takes effect for words that were previously added with `addWordsToDictionary`. This means that trying to remove a word that is included in the dictionary of the language file (e.g. `"hello"`) does not take any effect.
    }
    
    // MARK: - (Private) Other methods
    
    private func subscribeToLanguageFileChanges() {
        LanguagesManager.shared.languageFileUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.reloadLanguageFile()
            }
            .store(in: &self.subscriptions)
    }
    
    private func reloadLanguageFile() {
        do {
            try self.predictiveService?.reloadLanguageFile(LanguagesManager.shared.latestLanguageFileURL)
            self.localeLanguageVersionNameSubject.value = LanguagesManager.shared.localeVersion
        } catch {
            NSLog("Could not reload language file: %@", error.localizedDescription)
            LanguagesManager.shared.onInvalidLanguageFile()
        }
    }
}
