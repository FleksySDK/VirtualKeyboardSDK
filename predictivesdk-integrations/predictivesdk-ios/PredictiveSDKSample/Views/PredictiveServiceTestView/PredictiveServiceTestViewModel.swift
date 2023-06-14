//
//  PredictiveServiceTestViewModel.swift
//  PredictiveSDKSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import Foundation
import Combine
import PredictiveSDK

class PredictiveServiceTestViewModel: ObservableObject {
    
    @Published var textValue: String = "" {
        didSet {
            if oldValue != self.textValue {
                self.resetValues()
            }
        }
    }
    @Published var textSelection: ClosedRange<UInt> = 0...0
    
    @Published private(set)var candidates: [Candidate] = []
    
    private var error: PredictiveServiceManager.FleksyError? {
        didSet {
            self.errorMessage = {
                switch error {
                case .invalidLicense:
                    return Constants.ErrorMessages.PredictiveServiceManager.invalidLicense
                case .invalidURL:
                    return Constants.ErrorMessages.PredictiveServiceManager.invalidLanguage
                case .unknown:
                    return Constants.ErrorMessages.PredictiveServiceManager.unknown
                case .languageFileNotFound:
                    return Constants.ErrorMessages.PredictiveServiceManager.languageFileNotFound
                case .none:
                    return nil
                }
            }()
        }
    }
    
    @Published var errorMessage: String?
    @Published var buttonPressed: String?
    @Published var localeLanguageVersion: String = ""
    
    private var predictiveServiceManager: PredictiveServiceManager
    private var subscriptions: Set<AnyCancellable> = []
    
    private var isBlocked: Bool { self.error == .invalidURL }
    
    init(predictiveServiceManager: PredictiveServiceManager = .shared) {
        self.predictiveServiceManager = predictiveServiceManager
        
        self.addSubscriptions()
    }
    
    deinit {
        self.removeSubscriptions()
    }
    
    func applyCandidate(_ candidate: Candidate) {
        let text = candidate.applyReplacements(to: self.textValue)
        self.textValue = text
        self.textSelection = UInt(text.count)...UInt(text.count)
    }
        
    func showAutoCorrectAction() {
        self.buttonPressed = "Autocorrection"
        guard !self.isBlocked else {
            self.candidates = []
            return
        }
        
        self.predictiveServiceManager.currentWordPrediction(self.textValue, start: self.textSelection.lowerBound, end: self.textSelection.upperBound)
    }
    
    func showSuggestionsAction() {
        self.buttonPressed = "Suggestions"
        guard !self.isBlocked else {
            self.candidates = []
            return
        }
        
        self.predictiveServiceManager.nextWordPrediction(self.textValue, start: self.textSelection.lowerBound, end: self.textSelection.upperBound)
    }
    
    private func resetValues() {
        self.candidates = []
        self.buttonPressed = nil
        if !self.isBlocked {
            self.error = nil
        }
    }
    
    private func addSubscriptions() {
        self.predictiveServiceManager.candidatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let candidates):
                    self?.error = nil
                    self?.candidates = candidates
                case . failure(let error):
                    self?.error = error
                    self?.candidates = []
                }
            })
            .store(in: &self.subscriptions)
        
        self.predictiveServiceManager.localeLanguageVersionNamePublisher
            .receive(on: DispatchQueue.main)
            .map {
                $0 ?? "No language file found"
            }
            .assign(to: &self.$localeLanguageVersion)
    }
    
    private func removeSubscriptions() {
        self.subscriptions.forEach {
            $0.cancel()
        }
        self.subscriptions.removeAll()
    }
}
