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
        return [
            .selection(SelectionSetting(titleKey: "Keyboard sounds",
                                        getter: { .keyboardSounds(.init(sdkSoundMode: FleksyManagedSettings.soundMode)) },
                                        setter: {
                                            guard case .keyboardSounds(let keyboardSounds) = $0 else { fatalError() }
                                            FleksyManagedSettings.soundMode = keyboardSounds.sdkSoundMode
                                        },
                                        allItemsGetter: { KeyboardSoundSelectionItem.getAllKeyboardSoundsSelectionItems()
                                        })),
            .bool(BoolSetting(titleKey: "Keyboard haptics",
                              subtitleKey: "The keyboard produce haptic feedback whenever you tap it. Requires Full Access",
                              getter: { FleksyManagedSettings.haptics },
                              setter: { FleksyManagedSettings.haptics = $0 })),
        ]
    }
}
