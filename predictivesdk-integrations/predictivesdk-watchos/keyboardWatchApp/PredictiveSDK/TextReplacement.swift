//  TextReplacement.swift
//  keyboard Watch App
//
//  Created on 13/2/23
//  
//

import Foundation

struct TextReplacement: Hashable {
    /// The text to show to the user for the text replacement.
    let textToShow: String
    
    /// The resulting text of applying the text replacement.
    let finalText: String
    
    /// A boolean indicating whether the replacement happens automatically when the user taps the space bar
    let isAutomatic: Bool
}
