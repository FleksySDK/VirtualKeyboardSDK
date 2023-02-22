//  TypedTextProxy.swift
//  keyboard Watch App
//
//  Created on 9/2/23
//  
//

import Foundation

@MainActor
class TypedTextProxy: ObservableObject {
    
    private var fullText: String = .emptyString {
        didSet {
            text = TextWithHighlight(initialText: fullText, highlightedText: .emptyString)
        }
    }
    
    @Published private(set) var licenseIsValid: Bool = true
    @Published private(set) var keyboardMode = KeyboardMode(shift: .uppercase)
    @Published private(set) var text: TextWithHighlight = .empty
    @Published private(set) var highlightedText: String = .emptyString
    @Published private(set) var loadingReplacements: Bool = false
    @Published private(set) var textReplacements: [TextReplacement] = [] {
        didSet {
            if textReplacements.isEmpty || fullText.last == String.spaceCharacter {
                text = TextWithHighlight(initialText: fullText, highlightedText: .emptyString)
            } else {
                let separators: CharacterSet = .punctuationCharacters.union(.whitespacesAndNewlines)
                let highlightedText = fullText.components(separatedBy: separators).last ?? .emptyString
                let initialText: String
                if highlightedText.count == fullText.count {
                    initialText = .emptyString
                } else {
                    initialText = String(fullText.prefix(fullText.count - highlightedText.count))
                }
                text = TextWithHighlight(initialText: initialText, highlightedText: highlightedText)
            }
        }
    }
    
    private var coreSDKInteractor: CoreSDKInteractor?
    
    init() {
        loadNextWordPrediction()
    }
    
    func reloadCoreSDK(layout: KeyboardLayout) {
        self.coreSDKInteractor = CoreSDKInteractor(layout: layout)
        loadNextWordPrediction()
    }
    
    func insertCharacter(_ character: Character, tapLocation: CGPoint) {
        if character == String.spaceCharacter {
            if let firstReplacement = textReplacements.first, firstReplacement.isAutomatic {
                onSelectReplacement(firstReplacement)
            } else {
                fullText.append(keyboardMode.applyShift(to: character))
            }
            loadNextWordPrediction()
        } else {
            fullText.append(keyboardMode.applyShift(to: character))
            loadCurrentWordPrediction(lastTapLocation: tapLocation)
        }
        keyboardMode.changeToLowercaseShiftIfNeeded()
    }
    
    func shiftAction() {
        keyboardMode.toggleShift()
    }
    
    func shiftUppercaseLockAction() {
        keyboardMode.shift = .uppercaseLocked
    }
    
    func deleteCharacter() {
        guard !fullText.isEmpty else { return }
        let deletedCharacter = fullText.removeLast()
        coreSDKInteractor?.didDeleteCharacter(character: deletedCharacter, newContext:fullText)
        if let lastCharacter = fullText.unicodeScalars.last, CharacterSet.alphanumerics.contains(lastCharacter) {
            loadCurrentWordPredictionWithoutLastTapLocation()
        } else {
            loadNextWordPrediction()
        }
        if fullText.isEmpty {
            keyboardMode.resetToUppercaseIfNeeded()
        }
    }
    
    func deleteAllCharacters() {
        fullText = .emptyString
        coreSDKInteractor?.didDeleteAllCharacters()
        loadNextWordPrediction()
        keyboardMode.resetToUppercaseIfNeeded()
    }
    
    func onFinishSwipe(_ swipePoints: [SwipePoint]) {
        guard let coreSDKInteractor else { return }
        Task {
            let suffix: String = fullText.last == String.spaceCharacter ? .emptyString : .spaceString
            let newText = await coreSDKInteractor.swipe(context: fullText + suffix, swipePoints: swipePoints)
            let licenseIsValid = newText != nil
            if licenseIsValid != self.licenseIsValid {
                self.licenseIsValid = licenseIsValid
            }
            if let newText {
                fullText = newText + String.spaceString
                loadNextWordPrediction()
            }
        }
    }
    
    func onSelectReplacement(_ replacement: TextReplacement) {
        fullText = replacement.finalText + String.spaceString
        loadNextWordPrediction()
    }
    
    // MARK: - Private methods
    
    private func loadNextWordPrediction() {
        Task {
            loadingReplacements = true
            let replacements = (await coreSDKInteractor?.nextWordPrediction(context: fullText))
            let licenseIsValid = replacements != nil
            if licenseIsValid != self.licenseIsValid {
                self.licenseIsValid = licenseIsValid
            }
            textReplacements = replacements ?? []
            loadingReplacements = false
        }
    }
    
    private func loadCurrentWordPrediction(lastTapLocation: CGPoint) {
        Task {
            loadingReplacements = true
            let replacements = (await coreSDKInteractor?.currentWordPrediction(lastTapAt: lastTapLocation, context: fullText))
            let licenseIsValid = replacements != nil
            if licenseIsValid != self.licenseIsValid {
                self.licenseIsValid = licenseIsValid
            }
            textReplacements = replacements ?? []
            loadingReplacements = false
        }
    }
    
    private func loadCurrentWordPredictionWithoutLastTapLocation() {
        Task {
            loadingReplacements = true
            let replacements = (await coreSDKInteractor?.currentWordPredictionWithoutTaps(context: fullText))
            let licenseIsValid = replacements != nil
            if licenseIsValid != self.licenseIsValid {
                self.licenseIsValid = licenseIsValid
            }
            textReplacements = replacements ?? []
            loadingReplacements = false
        }
    }
}
