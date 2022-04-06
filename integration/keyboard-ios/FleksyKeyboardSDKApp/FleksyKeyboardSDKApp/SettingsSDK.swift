//
//  SettingsSDK.swift
//  FleksyKeyboardSDKApp
//
//  Copyright © 2021 Thingthing,Ltd. All rights reserved.
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
        let accessibilityPrefix = Constants.Accessibility.SectionPrefix.look
        return [
            .selection(SelectionSetting(titleKey: "Keyboard font",
                                        key: FLEKSY_SETTINGS_KEYPAD_FONT,
                                        accessibilityPrefix: accessibilityPrefix + "Font.",
                                        allItemsGetter: {
                                            return FontSelectionItem.getAllFontSelectionItems(accessibilityPrefix: accessibilityPrefix + "Font.")
                                        })),
            .bool(BoolSetting(titleKey: "Show language on spacebar",
                              key: FLEKSY_SETTINGS_DISPLAY_LANGUAGE,
                              accessibilityPrefix: accessibilityPrefix + "ShowLanguageOnSpacebar.")),
            .selection(SelectionSetting(titleKey: "Special key",
                                        subtitleKey: "Change the function of the button to the left of the spacebar",
                                        orderingKey: FLEKSY_SETTINGS_MAGIC_BUTTON_ORDER,
                                        key: FLEKSY_SETTINGS_CONFIGURABLE_BUTTON,
                                        accessibilityPrefix: accessibilityPrefix + "SpecialKey.",
                                        allItemsGetter: {
                                            return SpecialKeySelectionItem.getAllSpecialKeySelectionItems(accessibilityPrefix: accessibilityPrefix + "SpecialKey.")
                                        }))
        ]
    }
    
    static var gesturesSettings: [SettingModel] {
        let accessibilityPrefix = Constants.Accessibility.SectionPrefix.gestures
        return [
            .bool(BoolSetting(titleKey: "Enable swipe typing",
                              key: FLEKSY_SETTINGS_SWIPETYPING,
                              accessibilityPrefix: accessibilityPrefix + "EnableSwipeTyping."))
        ]
    }
    
    static var typingSettings: [SettingModel] {
        let accessibilityPrefix = Constants.Accessibility.SectionPrefix.typing
        return [
            .bool(BoolSetting(titleKey: "Auto-correction",
                              key: FLEKSY_SETTINGS_USER_AUTO_CORRECTION,
                              accessibilityPrefix: accessibilityPrefix + "AutoCorrection.")),
            .bool(BoolSetting(titleKey: "Auto-capitalization",
                              key: FLEKSY_SETTINGS_USER_AUTO_CAPITALIZATION,
                              accessibilityPrefix: accessibilityPrefix + "AutoCapitalization.")),
            .bool(BoolSetting(titleKey: "Double-space period",
                              key: FLEKSY_SETTINGS_DOUBLE_TAP_PERIODS,
                              accessibilityPrefix: accessibilityPrefix + "DoubleSpacePeriod.")),
            .bool(BoolSetting(titleKey: "Autospace after punctuation",
                              isInverted: true,
                              key: FLEKSY_SETTINGS_DISABLE_SMART_SPACING,
                              accessibilityPrefix: accessibilityPrefix + "DisableSmartSpacing.")),
            .bool(BoolSetting(titleKey: "Case sensitive layout",
                              key: FLEKSY_SETTINGS_DISPLAY_LOWERCASE_LETTERS,
                              accessibilityPrefix: accessibilityPrefix + "DisplayLowercaseLetters.")),
            .bool(BoolSetting(titleKey: "Delete Correction",
                              subtitleKey: "When the word you were writing is corrected and you press the \"delete\" key, fleksy automatically reverts to the word previously written",
                              key: FLEKSY_SETTINGS_DELETE_CORRECTION,
                              accessibilityPrefix: accessibilityPrefix + "DeleteCorrection.")),
            .bool(BoolSetting(titleKey: "Auto-learn-words",
                              key: FLEKSY_SETTINGS_AUTOLEARN_FROM_USER,
                              accessibilityPrefix: accessibilityPrefix + "AutolearnFromUser.")),
            .bool(BoolSetting(titleKey: "Emoji Suggestion",
                              key: FLEKSY_SETTINGS_EMOJI_SUGGESTION,
                              accessibilityPrefix: accessibilityPrefix + "EmojiSuggestion.")),
            .bool(BoolSetting(titleKey: "Emoji Prediction",
                              key: FLEKSY_SETTINGS_EMOJI_PREDICTION,
                              accessibilityPrefix: accessibilityPrefix + "EmojiPrediction."))
        ]
    }
    
    static var soundSettings: [SettingModel] {
        let accessibilityPrefix = Constants.Accessibility.SectionPrefix.sound
        return [
            .bool(BoolSetting(titleKey: "Keyboard Clicks",
                              subtitleKey: "A click sound whenever you tap a key. Requires Full Access",
                              key: FLEKSY_SETTINGS_KEYBOARD_CLICKS,
                              accessibilityPrefix: accessibilityPrefix + "KeyboardClicks.")),
            .bool(BoolSetting(titleKey: "Swipe Sounds",
                              subtitleKey: "A swoosh sound whenever you swipe. Requires Full Access",
                              key: FLEKSY_SETTINGS_TYPING_SOUNDS,
                              accessibilityPrefix: accessibilityPrefix + "SwipeSounds.")),
            .bool(BoolSetting(titleKey: "Voice Feedback",
                              subtitleKey: "Announces the words after you type them. Requires Full Access",
                              key: FLEKSY_SETTINGS_SPEAK,
                              accessibilityPrefix: accessibilityPrefix + "VoiceFeedback"))
        ]
    }
}
