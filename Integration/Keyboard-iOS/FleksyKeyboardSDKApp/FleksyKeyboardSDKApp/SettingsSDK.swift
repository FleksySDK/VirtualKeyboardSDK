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
                                        getter: { .fontValue(.init(sdkKeyboardFont: FleksyManagedSettings.keyboardFont)) },
                                        setter: {
                                            guard case .fontValue(let fontValue) = $0 else { fatalError() }
                                            FleksyManagedSettings.keyboardFont = fontValue.sdkKeyboardFont
                                        },
                                        allItemsGetter: {
                                            return FontSelectionItem.getAllFontSelectionItems()
                                        })),
            .selection(SelectionSetting(titleKey: "Special key",
                                        subtitleKey: "Change the function of the button to the left of the spacebar",
                                        getter: { .mainMagicButton(.init(sdkMagicButtonAction: FleksyManagedSettings.magicButtonAction)) },
                                        setter: {
                                            guard case .mainMagicButton(let mainMagicButton) = $0 else { fatalError() }
                                            FleksyManagedSettings.magicButtonAction = mainMagicButton.sdkMagicButtonAction
                                        },
                                        ordering: { items in
                                            let sdkMagicButtonActions = items.map {
                                                guard case .mainMagicButton(let mainMagicButton) = $0 else { fatalError() }
                                                return mainMagicButton.sdkMagicButtonAction
                                            }
                                            FleksyManagedSettings.magicButtonLongPressActions = sdkMagicButtonActions
                                        },
                                        allItemsGetter: {
                                            return MagicButtonActionSelectionItem.getAllSpecialKeySelectionItems()
                                        })),
        ]
    }
    
    static var gesturesSettings: [SettingModel] {
        [
            .bool(BoolSetting(titleKey: "Enable swipe typing",
                              getter: { FleksyManagedSettings.swipeTyping },
                              setter: { FleksyManagedSettings.swipeTyping = $0 }))
        ]
    }
    
    static var typingSettings: [SettingModel] {
        return [
            .bool(BoolSetting(titleKey: "Auto-correction",
                              getter: { FleksyManagedSettings.autoCorrection },
                              setter: { FleksyManagedSettings.autoCorrection = $0 })),
            .bool(BoolSetting(titleKey: "Auto-correction after punctuation",
                              subtitleKey: "requires auto-correction ON",
                              getter: { FleksyManagedSettings.autoCorrectAfterPunctuation },
                              setter: { FleksyManagedSettings.autoCorrectAfterPunctuation = $0 })),
            .bool(BoolSetting(titleKey: "Auto-capitalization",
                              getter: { FleksyManagedSettings.autoCapitalization },
                              setter: { FleksyManagedSettings.autoCapitalization = $0 })),
            .bool(BoolSetting(titleKey: "Double-space ads punctuation",
                              getter: { FleksyManagedSettings.doubleSpaceTapAddsPunctuation },
                              setter: { FleksyManagedSettings.doubleSpaceTapAddsPunctuation = $0 })),
            .bool(BoolSetting(titleKey: "Smart punctuation",
                              subtitleKey: "Autospace after punctuation",
                              getter: { FleksyManagedSettings.smartPunctuation },
                              setter: { FleksyManagedSettings.smartPunctuation = $0 })),
            .bool(BoolSetting(titleKey: "Case sensitive layout",
                              getter: { FleksyManagedSettings.caseSensitive },
                              setter: { FleksyManagedSettings.caseSensitive = $0 })),
            .bool(BoolSetting(titleKey: "Backspace to undo auto correction",
                              subtitleKey: "When ON, if the word you were writing is corrected and you press the \"delete\" key, the keyboard automatically reverts to the word previously written",
                              getter: { FleksyManagedSettings.backspaceToUndoAutoCorrection },
                              setter: { FleksyManagedSettings.backspaceToUndoAutoCorrection = $0 })),
            .bool(BoolSetting(titleKey: "Auto-learn words",
                              getter: { FleksyManagedSettings.autoLearn },
                              setter: { FleksyManagedSettings.autoLearn = $0 })),
            .bool(BoolSetting(titleKey: "Emoji predictions",
                              getter: { FleksyManagedSettings.emojiPredictions },
                              setter: { FleksyManagedSettings.emojiPredictions = $0 })),
            .bool(BoolSetting(titleKey: "Words predictions",
                              getter: { FleksyManagedSettings.wordPredictions },
                              setter: { FleksyManagedSettings.wordPredictions = $0 })),
            .bool(BoolSetting(titleKey: "Use all accents",
                              subtitleKey: "When ON, holding on a key will show all possible accents, and not only the common accents for the current language.",
                              getter: { FleksyManagedSettings.useAllAccents },
                              setter: { FleksyManagedSettings.useAllAccents = $0 })),
            .bool(BoolSetting(titleKey: "Keyboard sounds",
                              subtitleKey: "The keyboard produce sounds whenever you tap it. Requires Full Access",
                              getter: {
                                  if case .silent = FleksyManagedSettings.soundMode {
                                      return false
                                  } else {
                                      return true
                                  }
                              },
                              setter: { FleksyManagedSettings.soundMode = $0 ? .sound() : .silent })),
            .bool(BoolSetting(titleKey: "Keyboard haptics",
                              subtitleKey: "The keyboard produce haptic feedback whenever you tap it. Requires Full Access",
                              getter: { FleksyManagedSettings.haptics },
                              setter: { FleksyManagedSettings.haptics = $0 }))
        ]
    }
}
