//
//  SettingsSDK.swift
//  FleksyKeyboardSDKApp
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import Foundation
import FleksyKeyboardSDK
import UIKit

struct SettingsSDK {
    static let userDefaults: UserDefaults = {
        let groupName = Bundle.main.object(forInfoDictionaryKey: "AppGroupName") as! String
        return UserDefaults(suiteName: groupName)!
    }()
    
    static var lookSettings: [SettingModel] {
        return [
            .selection(SelectionSetting(titleKey: "Keyboard font",
                                        key: FLEKSY_SETTINGS_KEYPAD_FONT,
                                        allItemsGetter: {
                                            return FontSelectionItem.getAllFontSelectionItems()
                                        })),
            .selection(SelectionSetting(titleKey: "Special key",
                                        subtitleKey: "Change the function of the button to the left of the spacebar",
                                        orderingKey: FLEKSY_SETTINGS_MAGIC_BUTTON_ORDER,
                                        key: FLEKSY_SETTINGS_CONFIGURABLE_BUTTON,
                                        allItemsGetter: {
                                            return SpecialKeySelectionItem.getAllSpecialKeySelectionItems()
                                        }))
        ]
    }
    
    static var gesturesSettings: [SettingModel] {
        [
            .bool(BoolSetting(titleKey: "Enable swipe typing",
                              key: FLEKSY_SETTINGS_SWIPETYPING))
        ]
    }
    
    static var typingSettings: [SettingModel] {
        return [
            .bool(BoolSetting(titleKey: "Auto-correction",
                              key: FLEKSY_SETTINGS_USER_AUTO_CORRECTION)),
            .bool(BoolSetting(titleKey: "Auto-capitalization",
                              key: FLEKSY_SETTINGS_USER_AUTO_CAPITALIZATION)),
            .bool(BoolSetting(titleKey: "Double-space period",
                              key: FLEKSY_SETTINGS_DOUBLE_TAP_PERIODS)),
            .bool(BoolSetting(titleKey: "Autospace after punctuation",
                              isInverted: true,
                              key: FLEKSY_SETTINGS_DISABLE_SMART_SPACING)),
            .bool(BoolSetting(titleKey: "Case sensitive layout",
                              key: FLEKSY_SETTINGS_DISPLAY_LOWERCASE_LETTERS)),
            .bool(BoolSetting(titleKey: "Delete Correction",
                              subtitleKey: "When the word you were writing is corrected and you press the \"delete\" key, fleksy automatically reverts to the word previously written",
                              key: FLEKSY_SETTINGS_DELETE_CORRECTION)),
            .bool(BoolSetting(titleKey: "Auto-learn-words",
                              key: FLEKSY_SETTINGS_AUTOLEARN_FROM_USER)),
            .bool(BoolSetting(titleKey: "Emoji Suggestion",
                              key: FLEKSY_SETTINGS_EMOJI_SUGGESTION)),
            .bool(BoolSetting(titleKey: "Emoji Prediction",
                              key: FLEKSY_SETTINGS_EMOJI_PREDICTION))
        ]
    }
    
    static var soundSettings: [SettingModel] {
        return [
            .bool(BoolSetting(titleKey: "Keyboard Clicks",
                              subtitleKey: "A click sound whenever you tap a key. Requires Full Access",
                              key: FLEKSY_SETTINGS_KEYBOARD_CLICKS)),
            .bool(BoolSetting(titleKey: "Swipe Sounds",
                              subtitleKey: "A swoosh sound whenever you swipe. Requires Full Access",
                              key: FLEKSY_SETTINGS_TYPING_SOUNDS)),
            .bool(BoolSetting(titleKey: "Voice Feedback",
                              subtitleKey: "Announces the words after you type them. Requires Full Access",
                              key: FLEKSY_SETTINGS_SPEAK))
        ]
    }
}
