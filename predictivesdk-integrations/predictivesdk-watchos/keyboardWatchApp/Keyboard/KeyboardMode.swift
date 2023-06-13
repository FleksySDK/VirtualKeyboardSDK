//  KeyboardMode.swift
//  keyboard Watch App
//
//  Created on 14/2/23
//  
//

import SwiftUI

class KeyboardMode: ObservableObject {
    enum Shift {
        case lowercase
        case uppercase
        case uppercaseLocked
    }
    
    func applyShift(to character: Character) -> String {
        switch self.shift {
        case .lowercase:
            return String(character).lowercased()
        case .uppercase, .uppercaseLocked:
            return String(character).uppercased()
        }
    }
    
    func toggleShift() {
        switch self.shift {
        case .uppercaseLocked, .uppercase:
            self.shift = .lowercase
        case .lowercase:
            self.shift = .uppercase
        }
    }
    
    func changeToLowercaseShiftIfNeeded() {
        if self.shift == .uppercase {
            self.shift = .lowercase
        }
    }
    
    func resetToUppercaseIfNeeded() {
        if self.shift == .lowercase {
            self.shift = .uppercase
        }
    }
    
    @Published var shift: Shift
    
    init(shift: Shift) {
        self.shift = shift
    }
}
