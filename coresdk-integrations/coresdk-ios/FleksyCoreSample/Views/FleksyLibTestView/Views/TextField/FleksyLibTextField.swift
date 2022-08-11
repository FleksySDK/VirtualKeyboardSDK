//
//  FleksyLibTextField.swift
//  FleksyCoreSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import SwiftUI

struct FleksyLibTextField: UIViewRepresentable {
    typealias UIViewType = CustomTextField
    
    @Binding private var text: String
    @Binding private var selection: ClosedRange<UInt>
    private let placeHolder: String
    
    init(text: Binding<String>, placeHolder: String, selection: Binding<ClosedRange<UInt>>) {
        self._text = text
        self._selection = selection
        self.placeHolder = placeHolder
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self.$text, selection: self.$selection)
    }
    
    func makeUIView(context: Context) -> CustomTextField {
        let textField = CustomTextField()
        textField.text = self.text
        textField.placeholder = self.placeHolder
        
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(Coordinator.didChangeText(_:)), for: .editingChanged)
        
        return textField
    }
    
    func updateUIView(_ uiView: CustomTextField, context: Context) {
        uiView.text = self.text
    }
    
    // MARK: - FleksyLibTextField Coordinator
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding private var text: String
        @Binding private var selection: ClosedRange<UInt>
    
        init(_ text: Binding<String>, selection: Binding<ClosedRange<UInt>>) {
            self._text = text
            self._selection = selection
        }
        
        @objc func didChangeText(_ textField: CustomTextField) {
            self.text = textField.text ?? ""
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.selection = textField.selection
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}
