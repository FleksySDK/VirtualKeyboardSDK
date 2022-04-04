//
//  SettingModels.swift
//  FleksyKeyboardSDKApp
//
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
    private let isInverted: Bool
    fileprivate let key: String
    let accessibilityPrefix: String
    
    init(titleKey: String, subtitleKey: String? = nil, isInverted: Bool = false, key: String, accessibilityPrefix: String) {
        self.titleKey = titleKey
        self.subtitleKey = subtitleKey
        self.isInverted = isInverted
        self.key = key
        self.accessibilityPrefix = accessibilityPrefix
    }
    
    func get() -> Bool {
        let value = SettingsSDK.userDefaults.bool(forKey: key)
        return isInverted ? !value : value
    }
    
    func set(value: Bool) {
        let finalValue = isInverted ? !value : value
        SettingsSDK.userDefaults.set(finalValue, forKey: key)
    }
}

// MARK: - Selection setting

protocol SelectionItem {
    var titleKey: String { get }
    var subtitleKey: String? { get }
    var accessibilityPrefix: String { get }
    var value: SelectionItemValue { get }
    var modificator: ItemModificator? { get }
}

/// Type used to apply an extra (visual) modificator to the selection items.
enum ItemModificator {
    case font(name: String)
}

/// Type that contains the object that is set into the `UserDefaults`.
enum SelectionItemValue: Equatable {
    
    enum ValueError: Error {
        /// Sent when trying to operate on an array of `SelectionItemValue` items that are not of the same case.
        case heterogeneousArray
    }
    
    case string(String)
    case integer(Int)
    
    init?(from value: Any?) {
        switch value {
        case let str as String:
            self = .string(str)
        case let integer as Int:
            self = .integer(integer)
        default:
            return nil
        }
    }
}

struct SelectionSetting: Selectable {
    let titleKey: String
    let subtitleKey: String?
    var items: [SelectionItem] {
        return itemsGetter()
    }
    var allowsSorting: Bool {
        return !(orderingKey?.isEmpty ?? true)
    }
    fileprivate let key: String
    
    fileprivate let orderingKey: String?
    private let itemsGetter: () -> [SelectionItem]
    let accessibilityPrefix: String
    
    init(titleKey: String, subtitleKey: String? = nil, orderingKey: String? = nil, key: String, accessibilityPrefix: String, allItemsGetter: @escaping () -> [SelectionItem]) {
        self.titleKey = titleKey
        self.subtitleKey = subtitleKey
        self.orderingKey = orderingKey
        self.key = key
        self.accessibilityPrefix = accessibilityPrefix
        self.itemsGetter = allItemsGetter
    }
    
    func getSelected() -> SelectionItem? {
        guard let valueInDefaults = SettingsSDK.userDefaults.value(forKey: key),
              let value = SelectionItemValue(from: valueInDefaults) else {
            return nil
        }
        return items.first {
            $0.value == value
        }
    }

    func setSelected(_ item: SelectionItem) {
        switch item.value {
        case .string(let str):
            SettingsSDK.userDefaults.set(str, forKey: key)
        case .integer(let integer):
            SettingsSDK.userDefaults.set(integer, forKey: key)
        }
    }
    
    func itemsOrderUpdated(_ sortedItems: [SelectionItem]) {
        guard let orderingKey = orderingKey else {
            return
        }
            
        let sortedValues = sortedItems.map {
            $0.value
        }.map { (value) -> Any in
            switch value {
            case .string(let str):
                return str
            case .integer(let integer):
                return NSNumber(value: integer)
            }
        }
        
        guard sortedValues is [String]
                || sortedValues is [NSNumber]
        else {
            fatalError("Trying to save heterogeneous array into UserDefaults")
        }
        SettingsSDK.userDefaults.set(sortedValues, forKey: orderingKey)
    }
}

// MARK: Font

struct FontSelectionItem: SelectionItem {
    private let fontName: String
    var titleKey: String {
        fontName
    }
    let subtitleKey: String? = nil
    let accessibilityPrefix: String
    var value: SelectionItemValue {
        .string(fontName)
    }
    var modificator: ItemModificator? {
        return .font(name: self.fontName)
    }
    
    init(fontName: String, accessibilityPrefix: String) {
        self.fontName = fontName
        self.accessibilityPrefix = accessibilityPrefix
    }
    
    static func getAllFontSelectionItems(accessibilityPrefix: String) -> [FontSelectionItem] {
        return [
            "System Font",
            "Gilroy-Medium",
            "HelveticaNeue",
            "HelveticaNeue-Bold",
            "HelveticaNeue-Thin",
            "Futura-MediumItalic",
            "Menlo-Regular",
            "Avenir-Light",
            "System Font Bold"
        ].map {
            FontSelectionItem(fontName: $0, accessibilityPrefix: accessibilityPrefix + $0.replacingOccurrences(of: " ", with: "-") + ".")
        }
    }
}

// MARK: Magic key

struct SpecialKeySelectionItem: SelectionItem {
    let titleKey: String
    let subtitleKey: String? = nil
    let integerValue: Int
    let accessibilityPrefix: String
    var value: SelectionItemValue {
        .integer(integerValue)
    }
    var modificator: ItemModificator? = nil

    static func getAllSpecialKeySelectionItems(accessibilityPrefix: String) -> [SpecialKeySelectionItem] {
        let magicButtonsSorted = SettingsSDK.userDefaults.object(forKey: FLEKSY_SETTINGS_MAGIC_BUTTON_ORDER) as? [NSNumber] ?? []
        return magicButtonsSorted.compactMap { button in
            let data: (titleKey: String, accessibilityPrefix: String)? = {
                switch button.uint32Value {
                case FleksyControlTypeEmojiKey.rawValue:
                    return (NSLocalizedString("Emoji", comment: ""), "Emoji")
                case FleksyControlTypeCommaKey.rawValue:
                    return (NSLocalizedString("Comma", comment: ""), "Comma")
                case FleksyControlTypeHideKeyboardKey.rawValue:
                    return (NSLocalizedString("Dismiss Keyboard", comment: ""), "Dismiss-Keyboard")
                case FleksyControlTypeAutoCorrectOffKey.rawValue:
                    return (NSLocalizedString("Autocorrect Toggle", comment: ""), "Autocorrect")
                case FleksyControlTypeGlobeKey.rawValue:
                    return (NSLocalizedString("Globe (Switch Keyboard)", comment: ""), "Globe")
                default:
                    return nil
                }
            }()
            return data.map {
                SpecialKeySelectionItem(titleKey: $0.titleKey, integerValue: button.intValue, accessibilityPrefix: $0.accessibilityPrefix)
            }
        }
    }
}

