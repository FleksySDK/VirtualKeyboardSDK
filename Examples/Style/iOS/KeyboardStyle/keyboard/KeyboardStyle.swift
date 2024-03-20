//
//  KeyboardStyle.swift
//  keyboard
//
//  Copyright © 2024 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import Foundation
import FleksyKeyboardSDK

enum KeyboardStyle: Int {
    case light
    case blue
    case yellow
    case defaultStyle
    
    func next() -> KeyboardStyle {
        return KeyboardStyle(rawValue: rawValue + 1) ?? .light
    }
    
    func getStyleConfiguration() -> StyleConfiguration {
        
        let style: StyleConfiguration
        
        switch self {
        case .light:
            let theme = getLightTheme()
            style = StyleConfiguration(theme: theme, darkTheme: theme)
        case .blue:
            let theme = getBlueTheme()
            style = StyleConfiguration(theme: theme, darkTheme: theme)
        case .yellow:
            let theme = getYellowTheme()
            style = StyleConfiguration(theme: theme, darkTheme: theme)
        case .defaultStyle:
            style = StyleConfiguration()
        }
        return style
    }
    
    private func getLightTheme() -> KeyboardTheme {
        
        // KEYBOARD STYLE
        let lightTheme = KeyboardTheme(key: "keyLightTheme",
                                       name: "LightTheme",
                                       keyLetters: UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0), // #222222
                                       keyBackground: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                       keyShadow: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25),
                                       hoverLetters: UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0), // #222222
                                       hoverBackground: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                       hoverSelectedLetters: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                       hoverSelectedBackground: UIColor(red: 0.0, green: 145.0/255.0, blue: 255.0/255.0, alpha: 1.0), // #0091ff
                                       suggestionLetters: UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0), // #222222
                                       suggestionSelectedLetters: UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0), // #222222
                                       buttonBackground: UIColor(red: 179.0/255.0, green: 184.0/255.0, blue: 192.0/255.0, alpha: 1.0), // #b3b8c0
                                       buttonBackgroundPressed: UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0), // #f8f8f8
                                       spacebarBackground: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                       swipeLine: UIColor(red: 168.0/255.0, green: 168.0/255.0, blue: 168.0/255.0, alpha: 1.0) // #a8a8a8
        )
        return lightTheme
    }
    
    private func getBlueTheme() -> KeyboardTheme {
        
        // KEYBOARD STYLE
        let blueTheme = KeyboardTheme(key: "keyBlueTheme",
                                      name: "BlueTheme",
                                      backgroundGradient: [UIColor(red: 218.0/255.0, green: 240.0/255.0, blue: 255.0/255.0, alpha: 1.0)],
                                      keyLetters: UIColor(red: 70.0/255.0, green: 182.0/255.0, blue: 254.0/255.0, alpha: 1.0),
                                      keyBackground: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                      keyShadow: UIColor(red: 70.0/255.0, green: 182.0/255.0, blue: 254.0/255.0, alpha: 0.25),
                                      hoverLetters: UIColor(red: 70.0/255.0, green: 182.0/255.0, blue: 254.0/255.0, alpha: 1.0),
                                      hoverBackground: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                      hoverSelectedLetters: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                      hoverSelectedBackground: UIColor(red: 0.0, green: 145.0/255.0, blue: 255.0/255.0, alpha: 1.0), // #0091ff
                                      suggestionLetters: UIColor(red: 70.0/255.0, green: 182.0/255.0, blue: 254.0/255.0, alpha: 1.0),
                                      suggestionSelectedLetters: UIColor(red: 70.0/255.0, green: 182.0/255.0, blue: 254.0/255.0, alpha: 1.0),
                                      buttonBackground: UIColor(red: 181.0/255.0, green: 226/255.0, blue: 255.0/255.0, alpha: 1.0),
                                      buttonBackgroundPressed: UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0), // #f8f8f8
                                      spacebarBackground: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                      swipeLine: UIColor(red: 106.0/255.0, green: 197.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        )
        return blueTheme
    }
    
    private func getYellowTheme() -> KeyboardTheme {
        
        // Keyboard Sytle Background
        let yellowTheme = KeyboardTheme(key: "keyYellowTheme",
                                        name: "YellowTheme",
                                        image: "background",
                                        imagePosition: .scale,
                                        keyLetters: UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0), // #222222
                                        keyBackground: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                        keyShadow: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25),
                                        hoverLetters: UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0), // #222222
                                        hoverBackground: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                        hoverSelectedLetters: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                        hoverSelectedBackground: UIColor(red: 201.0/255.0, green: 149.0/255.0, blue: 41.0/255.0, alpha: 1.0),
                                        suggestionLetters: UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0), // #222222
                                        suggestionSelectedLetters: UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0), // #222222
                                        buttonBackground: UIColor(red: 179.0/255.0, green: 184.0/255.0, blue: 192.0/255.0, alpha: 1.0), // #b3b8c0
                                        buttonBackgroundPressed: UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0), // #f8f8f8
                                        spacebarBackground: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
                                        swipeLine: UIColor(red: 201.0/255.0, green: 149.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        )
        return yellowTheme
    }
}
