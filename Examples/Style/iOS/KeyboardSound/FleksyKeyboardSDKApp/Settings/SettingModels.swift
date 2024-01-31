//
//  SettingModels.swift
//  FleksyKeyboardSDKApp
//
//  Created by Antonio Jesús Pallares Martín on 22/10/21.
//  Copyright © 2021 Thingthing,Ltd. All rights reserved.
//

import Foundation
import FleksyKeyboardSDK

enum SettingModel {
    case bool(BoolSetting)
    case selection(SelectionSetting)
}

// MARK: - On/off setting
        
struct BoolSetting {
    let titleKey: String
    let subtitleKey: String?
    private let getter: () -> Bool
    private let setter: (Bool) -> Void
    
    init(titleKey: String, subtitleKey: String? = nil, getter: @escaping () -> Bool, setter: @escaping (Bool) -> Void) {
        self.titleKey = titleKey
        self.subtitleKey = subtitleKey
        self.getter = getter
        self.setter = setter
    }
    
    func get() -> Bool {
        getter()
    }
    
    func set(value: Bool) {
        setter(value)
    }
}

// MARK: - Selection setting

protocol SelectionItem {
    var titleKey: String { get }
    var subtitleKey: String? { get }
    var value: SelectionItemValue { get }
}

/// Type that contains the object that is set into the `UserDefaults`.
enum SelectionItemValue: Equatable {
    
    enum KeyboardSounds: String, Codable, CaseIterable {
        case noSounds = "No sounds"
        case sdkDefault = "Default SDK sounds"
        case custom = "Custom sounds"
        
        var sdkSoundMode: FeedbackConfiguration.SoundMode {
            switch self {
            case .noSounds:
                return .silent
            case .sdkDefault:
                return .sound()
            case .custom:
                return .sound(FeedbackConfiguration.ResourceSoundSet(tap: "CustomTap.wav", button: "CustomButton.wav", backspace: "CustomBackspace.wav"))
            }
        }
        
        init(sdkSoundMode: FeedbackConfiguration.SoundMode) {
            switch sdkSoundMode {
            case .silent:
                self = .noSounds
            case .sound(let soundSet) where soundSet == .defaultSoundSet:
                self = .sdkDefault
            case .sound:
                self = .custom
            }
        }
    }
    
    case keyboardSounds(KeyboardSounds)
    
    init?(from value: Any?) {
        switch value {
        case let data as Data:
            let decoder = JSONDecoder()
            if let keyboardSound = try? decoder.decode(KeyboardSounds.self, from: data) {
                self = .keyboardSounds(keyboardSound)
            } else {
                return nil
            }
        default:
            return nil
        }
    }
}

struct KeyboardSoundSelectionItem: SelectionItem {
    
    let keyboardSounds: SelectionItemValue.KeyboardSounds
    let subtitleKey: String? = nil
    
    var titleKey: String {
        keyboardSounds.rawValue
    }
    var value: SelectionItemValue {
        .keyboardSounds(keyboardSounds)
    }
    
    static func getAllKeyboardSoundsSelectionItems() -> [KeyboardSoundSelectionItem] {
        SelectionItemValue.KeyboardSounds.allCases.map {
            KeyboardSoundSelectionItem(keyboardSounds: $0)
        }
    }
}

struct SelectionSetting: Selectable {
    let titleKey: String
    var items: [SelectionItem] {
        return itemsGetter()
    }
    private let getter: () -> SelectionItemValue
    private let setter: (SelectionItemValue) -> Void
    private let itemsGetter: () -> [SelectionItem]
    
    init(titleKey: String, subtitleKey: String? = nil, getter: @escaping () -> SelectionItemValue, setter: @escaping (SelectionItemValue) -> Void, allItemsGetter: @escaping () -> [SelectionItem]) {
        self.titleKey = titleKey
        self.getter = getter
        self.setter = setter
        self.itemsGetter = allItemsGetter
    }
    
    func getSelected() -> SelectionItem? {
        let value = getter()
        return items.first {
            $0.value == value
        }
    }

    func setSelected(_ item: SelectionItem) {
        setter(item.value)
    }
}
