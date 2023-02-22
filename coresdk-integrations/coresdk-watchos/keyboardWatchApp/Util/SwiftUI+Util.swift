//  SwiftUI+Util.swift
//  keyboard Watch App
//
//  Created on 8/2/23
//  
//

import SwiftUI

extension Color {
    
    static func randomBackgroundColor(for colorScheme: ColorScheme) -> Color {
        let range: Range<CGFloat> = {
            switch colorScheme {
            case .light:
                return 0.5..<0.9
            case .dark:
                return 0.1..<0.5
            @unknown default:
                return 0.9..<0.9
            }
        }()
        return randomColor(withLuminanceIn: range)
    }
    
    private static func randomColor(withLuminanceIn range: Range<CGFloat>) -> Color {
        var red: CGFloat = CGFloat.random(in: 0...1)
        var green: CGFloat = CGFloat.random(in: 0...1)
        var blue: CGFloat = CGFloat.random(in: 0...1)
        var luminance = luminance(red: red, green: green, blue: blue)
        
        while !range.contains(luminance) {
            let op: (CGFloat, CGFloat) -> CGFloat = luminance < range.lowerBound ? (+) : (-)
            red = min(1, max(0, op(red, 0.05)))
            green = min(1, max(0, op(green, 0.05)))
            blue = min(1, max(0, op(blue, 0.05)))
            luminance = self.luminance(red: red, green: green, blue: blue)
        }
        
        return Color(red: red, green: green, blue: blue)
    }
    
        
        
    private static func luminance(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
        0.2126 * red + 0.7152 * green + 0.0722 * blue
    }
}

// Taken from https://www.avanderlee.com/swiftui/conditional-view-modifier/
extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
