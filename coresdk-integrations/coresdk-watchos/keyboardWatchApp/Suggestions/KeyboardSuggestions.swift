//  KeyboardSuggestions.swift
//  keyboard Watch App
//
//  Created on 9/2/23
//  
//

import SwiftUI

struct KeyboardSuggestions: View {
    
    private let replacements: [TextReplacement]
    private let action: ((TextReplacement) -> Void)?
    
    init(replacements: [TextReplacement], action: ((TextReplacement) -> Void)? = nil) {
        self.replacements = replacements
        self.action = action
    }
    
    var body: some View {
        Group {
            if replacements.isEmpty {
                Text("No suggestion")
            } else {
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(replacements, id: \.self) { replacement in
                                Text(replacement.textToShow)
                                    .padding(.horizontal)
                                    .background(.tertiary)
                                    .if(replacement.isAutomatic, transform: { view in
                                        view.background(.secondary)
                                    })
                                    .cornerRadius(4)
                                    .onTapGesture {
                                        action?(replacement)
                                    }
                            }
                        }
                    }
                    .onAppear {
                        if let first = replacements.first {
                            scrollProxy.scrollTo(first)
                        }
                    }
                }
            }
        }
    }
}

struct KeyboardSuggestion_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardSuggestions(replacements: [
            TextReplacement(textToShow: "Hello", finalText: "Hello", isAutomatic: true),
            TextReplacement(textToShow: "fine", finalText: "I'm fine", isAutomatic: true)
        ])
        KeyboardSuggestions(replacements: [])
    }
}
