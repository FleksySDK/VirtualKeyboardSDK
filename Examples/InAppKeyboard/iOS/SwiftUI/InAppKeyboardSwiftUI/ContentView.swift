//  ContentView.swift
//  InAppKeyboardSwiftUI
//
//  Copyright © 2024 Thingthing,Ltd. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var textStandard: String = ""
    @State var textInAppKb: String = ""
    
    enum Field {
        case standard
        case inAppKeyboardtextField
    }
    
    // To programmatically control the keyboard focus
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Group {
                Text("Standard SwiftUI ")
                + Text("TextField").monospacedIfAvailable()
            }
            TextField("Type here with the system keyboard...", text: $textStandard)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .standard)
            
            Divider()
            
            Text("Custom text field using the in-app keyboard:")
            InAppKeyboardTextField(borderStyle: .roundedRect,
                                   placeholder: "Type here with Fleksy's in-app keyboard",
                                   text: $textInAppKb)
            .focused($focusedField, equals: .inAppKeyboardtextField) // To enable programmatic focusing
            
            Divider()
            
            Button("Focus on standard text field") {
                self.focusedField = .standard
            }
            .frame(maxWidth: .infinity)
            
            Button("Focus on in-app keyboard text field") {
                self.focusedField = .inAppKeyboardtextField
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
        .navigationTitle("In-app Keyboard+SwiftUI")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: dismissKeyboardButton)
    }
    
    private var dismissKeyboardButton: some View {
        Button("Dismiss keyboard", systemImage: "keyboard.chevron.compact.down") {
            self.focusedField = nil
        }
    }
}

#Preview {
    ContentView()
}

extension Text {
    func monospacedIfAvailable() -> Text {
        if #available(iOS 16.4, *) {
            return monospaced()
        } else {
            return self
        }
    }
}
