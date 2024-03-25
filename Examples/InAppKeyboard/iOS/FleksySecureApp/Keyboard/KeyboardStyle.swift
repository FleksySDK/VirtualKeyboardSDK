//
//  KeyboardStyle.swift
//  FleksyInAppKeyboard
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//

import UIKit
import FleksyKeyboardSDK

class KeyboardStyle{
    
    func factoryStyle(styleSelection: Int) -> StyleConfiguration{
        
        var style = StyleConfiguration()
        
        switch styleSelection{
        case 0:
            style = StyleConfiguration(theme:getLightStyle(), darkTheme:getLightStyle())
            break;
        case 1:
            style = StyleConfiguration(theme:getBlueStyle(), darkTheme:getBlueStyle())
            break;
        default:
            break;
        }
        return style
    }
    
    
    func getLightStyle()-> KeyboardTheme{
        
        // KEYBOARD STYLE
        let lightTheme = KeyboardTheme(   key: "keyLightTheme",
                                         name:"LightTheme",
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
    
    func getBlueStyle() -> KeyboardTheme{
        
        // KEYBOARD STYLE
        let blueTheme = KeyboardTheme(   key: "keyBlueTheme",
                                         name:"BlueTheme",
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
    
}
