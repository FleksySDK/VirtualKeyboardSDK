//  TypingView.swift
//  keyboard Watch App
//
//  Created on 7/2/23
//  
//

import SwiftUI

struct TypingView: View {
    @StateObject private var viewModel: Keyboard.ViewModel
    @StateObject private var textProxy: TypedTextProxy
    
    init(layout: KeyboardLayout = .enUS) {
        let textProxy = TypedTextProxy()
        self._textProxy = StateObject(wrappedValue: textProxy)
        
        let viewModel = Keyboard.ViewModel(layout: layout, textProxy: textProxy)
        
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var highlightedAttributedText: AttributedString {
        var attributes = AttributeContainer()
        attributes.backgroundColor = .secondary
        return AttributedString(textProxy.text.highlightedText, attributes: attributes)
    }
    
    var body: some View {
        Group {
            Group {
                Text(textProxy.text.initialText)
                + Text(highlightedAttributedText)
            }
            .frame(minHeight: 40)
            Spacer()
            Group {
                if !textProxy.licenseIsValid {
                    Text("Invalid license")
                        .bold()
                        .foregroundColor(.red)
                } else if textProxy.loadingReplacements {
                    ProgressView()
                } else {
                    KeyboardSuggestions(replacements: textProxy.textReplacements) {
                        textProxy.onSelectReplacement($0)
                    }
                }
            }
            .frame(height: 40)
            Keyboard(viewModel: viewModel)
        }
        .environmentObject(textProxy.keyboardMode)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TypingView(layout: .enUS)
    }
}
