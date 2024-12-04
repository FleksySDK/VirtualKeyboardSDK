//
//  SettingModels.swift
//  FleksyKeyboardSDKApp
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
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
            
    init(titleKey: String, subtitleKey: String? = nil, getter: @escaping () -> Bool, setter: @escaping (Bool) -> Void, isInverted: Bool = false) {
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
    var modificator: ItemModificator? { get }
}

/// Type used to apply an extra (visual) modificator to the selection items.
enum ItemModificator {
    case font(UIFont?)
}

/// Type that contains the object that is set into the `UserDefaults`.
enum SelectionItemValue: Equatable {
    
    enum KeyboardFontValue: Equatable {
        case system(weight: UIFont.Weight)
        case custom(name: String)
        
        var sdkKeyboardFont: StyleConfiguration.KeyboardFont {
            switch self {
            case .system(let weight):
                return .system(weight: weight)
            case .custom(let name):
                return .custom(fontName: name)
            }
        }
        
        init(sdkKeyboardFont: StyleConfiguration.KeyboardFont) {
            switch sdkKeyboardFont {
            case .system(let weight):
                self = .system(weight: weight)
            case .custom(let fontName):
                self = .custom(name: fontName)
            @unknown default:
                fatalError()
            }
        }
    }
    
    enum AppMagicButtonAction: String, Codable, CaseIterable {
        case globe
        case emoji
        case hideKeyboard = "hide keyboard"
        case comma
        case autoCorrectToggle = "auto correct toggle"
        
        var sdkMagicButtonAction: MagicButtonAction {
            switch self {
            case .globe: return .globe
            case .emoji: return .emoji
            case .hideKeyboard: return .hideKeyboard
            case .comma: return .comma
            case .autoCorrectToggle: return .autoCorrectToggle
            }
        }
        
        init(sdkMagicButtonAction: MagicButtonAction) {
            switch sdkMagicButtonAction {
            case .globe:
                self = .globe
            case .emoji:
                self = .emoji
            case .hideKeyboard:
                self = .hideKeyboard
            case .comma:
                self = .comma
            case .autoCorrectToggle:
                self = .autoCorrectToggle
            }
        }
    }
    
    case string(String)
    case integer(Int)
    case fontValue(KeyboardFontValue)
    case mainMagicButton(AppMagicButtonAction)
}

struct SelectionSetting: Selectable {
    let titleKey: String
    let subtitleKey: String?
    var items: [SelectionItem] {
        return itemsGetter()
    }
    var allowsSorting: Bool {
        return orderingClosure != nil
    }
    
    private let getter: () -> SelectionItemValue
    private let setter: (SelectionItemValue) -> Void
    private let orderingClosure: (([SelectionItemValue]) -> Void)?
    
    private let itemsGetter: () -> [SelectionItem]
    
    init(titleKey: String, subtitleKey: String? = nil, getter: @escaping () -> SelectionItemValue, setter: @escaping (SelectionItemValue) -> Void, ordering: (([SelectionItemValue]) -> Void)? = nil, allItemsGetter: @escaping () -> [SelectionItem]) {
        self.titleKey = titleKey
        self.subtitleKey = subtitleKey
        self.getter = getter
        self.setter = setter
        self.orderingClosure = ordering
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

// MARK: Font

struct FontSelectionItem: SelectionItem {
    private let fontValue: SelectionItemValue.KeyboardFontValue
    var titleKey: String {
        switch fontValue {
        case .system(let weight):
            return "System font \(weight.displayName)"
        case .custom(let name):
            return name
        }
    }
    let subtitleKey: String? = nil
    var value: SelectionItemValue {
        .fontValue(fontValue)
    }
    var modificator: ItemModificator? {
        switch fontValue {
        case .system(let weight):
            return .font(.systemFont(ofSize: 17, weight: weight))
        case .custom(let name):
            return .font(UIFont(name: name, size: 17))
        }
    }
    
    init(fontValue: SelectionItemValue.KeyboardFontValue) {
        self.fontValue = fontValue
    }
    
    static func getAllFontSelectionItems() -> [FontSelectionItem] {
        let systemFonts = UIFont.Weight.allCases.map {
            FontSelectionItem(fontValue: .system(weight: $0))
        }
        
        
                
        let otherFonts = UIFont.familyNames.sorted().flatMap {
            UIFont.fontNames(forFamilyName: $0)
        }.map {
            FontSelectionItem(fontValue: .custom(name: $0))
        }
        return systemFonts + otherFonts
    }
}

// MARK: Magic key

struct MagicButtonActionSelectionItem: SelectionItem {
    var titleKey: String {
        magicButtonAction.rawValue
    }
    let subtitleKey: String? = nil
    let magicButtonAction: SelectionItemValue.AppMagicButtonAction
    var value: SelectionItemValue {
        .mainMagicButton(magicButtonAction)
    }
    var modificator: ItemModificator? = nil

    static func getAllSpecialKeySelectionItems() -> [MagicButtonActionSelectionItem] {
        FleksyManagedSettings.magicButtonLongPressActions.map {
            let magicButtonAction = SelectionItemValue.AppMagicButtonAction(sdkMagicButtonAction: $0)
            return MagicButtonActionSelectionItem(magicButtonAction: magicButtonAction)
        }
    }
}

// MARK: - UIFont.Weight

extension UIFont.Weight: CaseIterable {
        
    // CaseIterable
    
    public static var allCases: [UIFont.Weight] {
        [
            UIFont.Weight.ultraLight,
            UIFont.Weight.thin,
            UIFont.Weight.light,
            UIFont.Weight.regular,
            UIFont.Weight.medium,
            UIFont.Weight.semibold,
            UIFont.Weight.bold,
            UIFont.Weight.heavy,
            UIFont.Weight.black
        ]
    }
    
    // Other
    
    var displayName: String {
        switch self {
        case .ultraLight: return "ultraLight"
        case .thin: return "thin"
        case .light: return "light"
        case .regular: return "regular"
        case .medium: return "medium"
        case .semibold: return "semibold"
        case .bold: return "bold"
        case .heavy: return "heavy"
        case .black: return "black"
        default: return "invalid UIFont.Weight"
        }
    }
}
