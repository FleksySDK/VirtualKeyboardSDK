//
//  Candidate.swift
//  FleksyCoreSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import Foundation
import FleksyCoreSDK

// MARK: - Candidate

extension Candidate {
    public func applyReplacements(to string: String) -> String {
        var returnValue = string
        for replacement in self.replacements {
            returnValue = replacement.apply(to: returnValue)
        }
        return returnValue
    }
    
    public func getCandidateType() -> String {
        switch self.type {
        case .prediction: return "Prediction"
        case .autocompletion: return "Autocompletion"
        case .autocorrection: return "Autocorrection"
        case .emoji: return "Emoji"
        case .dictionary: return "Dictionary"
        case .other: return "Other"
        @unknown default: return "Other"
        }
    }
}

extension Candidate: Identifiable {
    public var id: Candidate { self }
}

// MARK: - Replacement

extension Replacement {
    public func apply(to string: String) -> String {
        if self.start > string.count {
            return string + self.replacement
        } else {
            let start = string.index(string.startIndex, offsetBy: Int(self.start))
            let end = string.index(string.startIndex, offsetBy: min(Int(self.end), string.count))
            return string.replacingCharacters(in: start..<end, with: self.replacement)
        }
    }
}

extension Replacement: Identifiable {
    public var id: Replacement { self }
}
