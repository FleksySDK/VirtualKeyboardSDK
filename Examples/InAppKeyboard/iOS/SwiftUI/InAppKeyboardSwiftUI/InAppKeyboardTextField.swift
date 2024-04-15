//  InAppKeyboardTextField.swift
//  InAppKeyboardSwiftUI
//  
//  Copyright © 2024 Thingthing,Ltd. All rights reserved.
//

import SwiftUI

struct InAppKeyboardTextField: UIViewRepresentable {
    
    let keyboardType: UIKeyboardType
    let autocapitalizationType: UITextAutocapitalizationType
    let borderStyle: UITextField.BorderStyle
    let placeholder: String
    let fontStyle: UIFont.TextStyle
    /// You can add here all properties needed to customize the
    /// final text field (e.g. font, colors, etc.) and you'll be able to set them
    /// in the actual `UITextField` in `makeUIView(context:)`-
        
    init(keyboardType: UIKeyboardType = .default,
         autocapitalizationType: UITextAutocapitalizationType = .sentences,
         borderStyle: UITextField.BorderStyle = .none,
         placeholder: String = "",
         fontStyle: UIFont.TextStyle = .body,
         text: Binding<String>) {
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.borderStyle = borderStyle
        self.placeholder = placeholder
        self.fontStyle = fontStyle
        self._text = text
    }
    
    @Binding var text: String
    private var focused: Binding<Bool>?
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = autocapitalizationType
        textField.borderStyle = borderStyle
        textField.placeholder = placeholder
        textField.font = UIFont.preferredFont(forTextStyle: fontStyle)
        /// You can set here all the extra properties added above to customize
        /// the text field (e.g. font, colors, etc.).
        
        let coordinator = context.coordinator
        
        // To set the in-app keyboard for the text field
        textField.inputView = coordinator.keyboardViewController.view
        
        // To have the coordinator receive all text changes in the text field
        textField.addTarget(coordinator, action: #selector(Coordinator.textDidChange(_:)), for: .editingChanged)
        
        // To have SwiftUI respect the expected height for the text field
        textField.setContentHuggingPriority(.required, for: .vertical)
        
        return textField
    }
    
    func updateUIView(_ textField: UITextField, context: Context) {
        textField.text = text
        
        // To programmatically focus on/remove focus from the text field from SwiftUI
        if !textField.isFirstResponder && focused?.wrappedValue == true {
            textField.becomeFirstResponder()
        } else if textField.isFirstResponder && focused?.wrappedValue == false {
            textField.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
}

// MARK: - Coordinator

extension InAppKeyboardTextField {
    
    class Coordinator {
        /// It is essential that the `keyboardViewController` lifespan is linked to the `Coordinator`
        /// because it is a class and it remains the same instance even after the SwiftUI view redraws.
        /// The `InAppKeyboardTextField`, though, is a struct that get reinitialized every time there parent view
        /// redraws.
        let keyboardViewController: KeyboardViewController = .init()
        var text: Binding<String>
        
        init(_ text: Binding<String>) {
            self.text = text
        }
     
        @objc func textDidChange(_ sender: UITextField) {
            self.text.wrappedValue = sender.text ?? ""
        }
    }
}

// MARK: - Focus management

extension InAppKeyboardTextField {
    
    /// This method is used to link the text field focus state to a binding.
    /// This is only needed to be able to programmatically focus on/remove focus from
    /// the `InAppKeyboardTextField` using SwiftUI.
    func focused<Value>(_ binding: FocusState<Value>.Binding, equals value: Value, removeFocusWith removeFocusValue: Value) -> InAppKeyboardTextField {
        var view = self
        view.focused = Binding<Bool>(get: {
            binding.wrappedValue == value
        }, set: { focused in
            if focused {
                binding.wrappedValue = value
            }
        })
        return self
    }
    
}
