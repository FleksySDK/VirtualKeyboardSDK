//  TextWithHighlight.swift
//  keyboard Watch App
//
//  Created on 13/2/23
//  
//

import Foundation

struct TextWithHighlight {
    static let empty = TextWithHighlight(initialText: .emptyString, highlightedText: .emptyString)
    
    let initialText: String
    let highlightedText: String
}
