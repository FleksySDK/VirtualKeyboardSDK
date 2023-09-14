//
//  SettingsSDK.swift
//  FleksyKeyboardSDKApp
//
//  Created by Antonio Jesús Pallares Martín on 20/10/21.
//  Copyright © 2021 Thingthing,Ltd. All rights reserved.
//

import Foundation
import FleksyKeyboardSDK
import UIKit

struct SettingsSDK {
    static var soundSettings: [SettingModel] {
        let accessibilityPrefix = Constants.Accessibility.SectionPrefix.sound
        return [
            .bool(BoolSetting(titleKey: "Keyboard clicks",
                              subtitleKey: "The keyboard emits a click sound whenever you tap it. Requires Full Access",
                              key: FLEKSY_SETTINGS_KEYBOARD_CLICKS,
                              accessibilityPrefix: accessibilityPrefix + "KeyboardClicks.")),
            .bool(BoolSetting(titleKey: "Swipe Sounds",
                              subtitleKey: "A swoosh sound whenever you swipe. Requires Full Access",
                              key: FLEKSY_SETTINGS_TYPING_SOUNDS,
                              accessibilityPrefix: accessibilityPrefix + "SwipeSounds."))
        ]
    }
}
