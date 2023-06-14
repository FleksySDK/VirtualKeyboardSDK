//  KeyboardViewModel.swift
//  keyboard Watch App
//
//  Created on 8/2/23
//  
//

import Foundation
import SwiftUI
import Combine

extension Keyboard {
    
    @MainActor
    class ViewModel: ObservableObject {
        private let layout: KeyboardLayout
        private let textProxy: TypedTextProxy
        let swipeViewModel: KeyboardSwipe.ViewModel
        
        var observations: Set<AnyCancellable> = []
        
        init(layout: KeyboardLayout, textProxy: TypedTextProxy) {
            self.layout = layout
            self.textProxy = textProxy
            self.swipeViewModel = KeyboardSwipe.ViewModel(textProxy: textProxy)
        }
        
        func executeAction(_ action: KeyboardLayout.Key.Action, _ gesture: KeyboardKey.GestureType) {
            switch action {
            case .insertCharacter(let character):
                switch gesture {
                case .tap(let location):
                    textProxy.insertCharacter(character, tapLocation: location)
                case .longPress:
                    fatalError("Long press gesture not compatible with .insertCharacter action")
                case .doubleTap:
                    fatalError("Double tap gesture not compatible with .insertCharacter action")
                }
            case .return:
                //TODO: implement
                print("return")
            case .deleteBack:
                    textProxy.deleteCharacter()
            case .deleteAll:
                textProxy.deleteAllCharacters()
            case .shift:
                textProxy.shiftAction()
            case .shiftUppercaseLock:
                textProxy.shiftUppercaseLockAction()
            case .numbers:
                //TODO: implement
                print("numbers")
            case .emoji:
                //TODO: implement
                print("emoji")
            }
        }
        
        private var lastSize: CGSize = .zero
        
        func buildRows(in geometry: GeometryProxy) -> [KeyboardLayout.KeysRow] {
            let size = geometry.size
            if size != lastSize {
                layout.distributeKeys(availableSize: size)
                textProxy.reloadPredictiveSDK(layout: layout)
                lastSize = size
            }
            return layout.rows
        }
    }
}

