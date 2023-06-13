//  PredictiveSDKInteractor.swift
//  keyboard Watch App
//
//  Created on 9/2/23
//  
//

import Foundation
import PredictiveSDK

class PredictiveSDKInteractor {
    
    private static var enUS_FileURL: URL {
        Bundle.main.url(forResource: "resourceArchive-en-US", withExtension: "jet")!
    }
    
    private let fleksyLib: FleksyLib
    
    init?(layout: KeyboardLayout) {
        var keys: [LayoutKey] = []
        
        var nextOriginY: CGFloat = 0
        
        layout.rows.forEach { row in
            var nextOriginX: CGFloat = 0
            row.keys.forEach { key in
                nextOriginX += key.leftPadding
                if case .insertCharacter(let character) = key.tapAction {
                    let frame = CGRect(x: nextOriginX, y: nextOriginY, width: key.width, height: row.height)
                    let layoutKey = LayoutKey(rect: frame, labels: [String(character)])
                    keys.append(layoutKey)
                }
                nextOriginX += key.width + key.rightPadding
            }
            nextOriginY += row.height
        }
        
        let licenseConfig = LicenseConfiguration(licenseKey: "<YOUR-LICENSE-KEY>", licenseSecret: "<YOUR-LICENSE-SECRET>")
        let languageConfig = LanguageConfiguration(layout: LayoutType.custom(keys: keys))
        let libraryConfiguration = LibraryConfiguration(license: licenseConfig, language: languageConfig)
        
        guard let fleksyLib = try? FleksyLib(languageFileURL: PredictiveSDKInteractor.enUS_FileURL, configuration: libraryConfiguration) else {
            return nil
        }
        self.fleksyLib = fleksyLib
    }
    
    
    private var currentLayoutPoints: [LayoutPoint] = []
    
    /// `nil` means invalid license
    func currentWordPrediction(lastTapAt location: CGPoint, context: String) async -> [TextReplacement]? {
        let layoutPoint = LayoutPoint(point: location, timestamp: Date.timeIntervalSinceReferenceDate)
        currentLayoutPoints.append(layoutPoint)
        let typingContext = TypingContext(context: context)
        let result = await fleksyLib.currentWordPrediction(typingContext, currentWordTaps: currentLayoutPoints)
        switch result {
        case .success(let candidates):
            let sortedCandidates = candidates.sorted(by: {
                $0.score > $1.score
            })
            
            return sortedCandidates.textReplacements(for: context, firstElementIsAutomatic: true)
        case .failure(let failure):
            if failure == .licenseNotValid {
                return nil
            } else {
                return []
            }
        }
    }
    
    /// `nil` means invalid license
    func currentWordPredictionWithoutTaps(context: String) async -> [TextReplacement]? {
        let result = await fleksyLib.currentWordPrediction(context)
        switch result {
        case .success(let candidates):
            let sortedCandidates = candidates.sorted(by: {
                $0.score > $1.score
            })
                
            return sortedCandidates.textReplacements(for: context, firstElementIsAutomatic: true)
        case .failure(let failure):
            if failure == .licenseNotValid {
                return nil
            } else {
                return []
            }
        }
    }
    
    /// `nil` means invalid license
    func nextWordPrediction(context: String) async -> [TextReplacement]? {
        currentLayoutPoints.removeAll()
        let result = await fleksyLib.nextWordPrediction(context)
        switch result {
        case .success(let candidates):
            return candidates.sorted(by: {
                $0.score > $1.score
            }).textReplacements(for: context, firstElementIsAutomatic: false)
        case .failure(let failure):
            if failure == .licenseNotValid {
                return nil
            } else {
                return []
            }
        }
    }
        
    func didDeleteCharacter(character: Character, newContext: String) {
        currentLayoutPoints.removeAll()
    }
    
    func didDeleteAllCharacters() {
        currentLayoutPoints.removeAll()
    }
    
    /// `nil` means invalid license
    func swipe(context: String, swipePoints: [SwipePoint]) async -> String? {
        let layoutPoints = swipePoints.map {
            LayoutPoint(point: $0.location, timestamp: $0.timestamp)
        }
        let result = await fleksyLib.swipePrediction(TypingContext(context: context), swipePoints: layoutPoints)
        
        switch result {
        case .success(let candidates):
            let bestCandidate = candidates.max {
                $0.score < $1.score
            }
            return bestCandidate?.applyReplacements(to: context)
            
        case .failure(let failure):
            print("Error swipe: ", failure)
            return ""
        }
    }
}
