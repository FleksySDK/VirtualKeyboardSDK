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
    case action(ActionSetting)
}

// Use on public app to match settings properly
/// Used to stablish relationships between settings
enum BoolSettingRelation {
    /// Parent relationship: overrides dependant settings
    case overrides(String, isInverted: Bool)
    /// Child relationship: tries to match overriding settings
    case depends(String, isInverted: Bool)
    
    var key: String {
        let relationKey: String
        switch self {
        case .overrides(let childKey, isInverted: _):
            relationKey = childKey
        case .depends(let parentKey, isInverted: _):
            relationKey = parentKey
        }
        return relationKey
    }
    
    var isInverted: Bool {
        let isInverted: Bool
        switch self {
        case .overrides(_, isInverted: let inverted):
            isInverted = inverted
        case .depends(_, isInverted: let inverted):
            isInverted = inverted
        }
        return isInverted
    }
    
    var isOverride: Bool {
        switch self {
        case .overrides: return true
        default: return false
        }
    }
    
    var isDependant: Bool {
        switch self {
        case .depends: return true
        default: return false
        }
    }
    
    var relatedSetting: Constants.Settings.TypedSetting<Bool> { .init(key: self.key, default: false) }
    
    var bondValue: Bool {
        let value = self.relatedSetting.get()
        return self.isInverted ? !value : value
    }
}

// MARK: - On/off setting
        
struct BoolSetting {
    let titleKey: String
    let subtitleKey: String?
    let relations: [BoolSettingRelation]
    private let isInverted: Bool
    fileprivate let setting: Constants.Settings.TypedSetting<Bool>
    let accessibilityPrefix: String
    
    init(titleKey: String, subtitleKey: String? = nil, isInverted: Bool = false, key: String, relations: [BoolSettingRelation] = [], accessibilityPrefix: String) {
        self.titleKey = titleKey
        self.subtitleKey = subtitleKey
        self.relations = relations
        self.setting = Constants.Settings.TypedSetting<Bool>(key: key, default: false)
        self.isInverted = isInverted
        self.accessibilityPrefix = accessibilityPrefix
    }
    
    init(titleKey: String, subtitleKey: String? = nil, setting: Constants.Settings.TypedSetting<Bool>, accessibilityPrefix: String) {
        self.titleKey = titleKey
        self.subtitleKey = subtitleKey
        self.relations = []
        self.setting = setting
        self.isInverted = false
        self.accessibilityPrefix = accessibilityPrefix
    }
    
    var settingKey: String { self.setting.key } 
    
    func get() -> Bool {
        let bondValue = self.getBondValue()
        let value = setting.get() && bondValue
        return isInverted ? !value : value
    }
    
    func set(value: Bool) {
        let bondValue = self.getBondValue()
        var finalValue = value && bondValue
        finalValue = isInverted ? !finalValue : finalValue
        
        self.relations.filter({ $0.isOverride })
            .compactMap({ ($0.relatedSetting, $0.isInverted) })
            .forEach { (setting, isInverted) in
                setting.set(isInverted ? !finalValue : finalValue)
            }
        
        setting.set(finalValue)
    }
    
    private func getBondValue() -> Bool {
        let overrideRelations = self.relations.filter({ $0.isOverride })
        let bondValue = self.relations.filter({ relation in
            let overrideKeys = overrideRelations.compactMap({ $0.key })
            return relation.isDependant && !overrideKeys.contains(relation.key)
        })
            .compactMap({ $0.bondValue })
            .allSatisfy({ $0 })
        return bondValue
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
    case number(NSNumber)
    
    init?(from value: Any?) {
        switch value {
        case let str as String:
            self = .string(str)
        case let number as NSNumber:
            self = .number(number)
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
    fileprivate let defaultValue: SelectionItemValue?
    
    fileprivate let orderingKey: String?
    private let itemsGetter: () -> [SelectionItem]
    let accessibilityPrefix: String
    
    init(titleKey: String, subtitleKey: String? = nil, orderingKey: String? = nil, key: String, defaultValue: SelectionItemValue? = nil, accessibilityPrefix: String, allItemsGetter: @escaping () -> [SelectionItem]) {
        self.titleKey = titleKey
        self.subtitleKey = subtitleKey
        self.orderingKey = orderingKey
        self.key = key
        self.defaultValue = defaultValue
        self.accessibilityPrefix = accessibilityPrefix
        self.itemsGetter = allItemsGetter
    }
    
    func getSelected() -> SelectionItem? {
        var value: SelectionItemValue?
        if let valueInDefaults = Constants.Settings.userDefaults.value(forKey: key) {
            value = SelectionItemValue(from: valueInDefaults)
        }
        value = value ?? defaultValue
        if let value = value {
            return items.first {
                $0.value == value
            }
        } else {
            return nil
        }
    }

    func setSelected(_ item: SelectionItem) {
        switch item.value {
        case .string(let str):
            Constants.Settings.userDefaults.set(str, forKey: key)
        case .number(let number):
            Constants.Settings.userDefaults.set(number, forKey: key)
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
            case .number(let number):
                return number
            }
        }
        
        guard sortedValues is [String]
                || sortedValues is [NSNumber]
        else {
            fatalError("Trying to save heterogeneous array into UserDefaults")
        }
        Constants.Settings.userDefaults.set(sortedValues, forKey: orderingKey)
    }
}

// MARK: - GenericSelectionItem

struct GenericSelectionItem: SelectionItem {
    let titleKey: String
    let subtitleKey: String?
    let accessibilityPrefix: String
    let value: SelectionItemValue
    let modificator: ItemModificator? = nil
}

// MARK: - Action Setting

struct ActionSetting {
    let action: Action
    let accessibilityPrefix: String
    
    init(action: Action, accessibilityPrefix: String) {
        self.action = action
        self.accessibilityPrefix = accessibilityPrefix + action.titleKey.replacingOccurrences(of: " ", with: "-") + "."
    }
    
    var titleKey: String {
        action.titleKey
    }
        
    enum Action {
        /// Moves the data capture files from the shared container into the app's document folder so that it can be accessed from a computer.
        case moveDataCaptureFiles
        
        var titleKey: String {
            switch self {
            case .moveDataCaptureFiles:
                return "Gather data capture files"
            }
        }
        
        func execute() {
            switch self {
            case .moveDataCaptureFiles:
                moveDataCaptureFilesFromSharedContainerToDocumentsFolder()
            }
        }
        
        private func moveDataCaptureFilesFromSharedContainerToDocumentsFolder() {
            let destinationDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("DataCapture", isDirectory: true)
            try? FileManager.default.createDirectory(at: destinationDirectory, withIntermediateDirectories: true)
            guard let appGroupFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: getAppGroupIdentifier()) else {
                return
            }
            
            if let enumerator = FileManager.default.enumerator(at: appGroupFolder, includingPropertiesForKeys: [.isReadableKey], options: [.skipsHiddenFiles]) {
                for case let fileURL as URL in enumerator where isDataCaptureFile(fileURL) {
                    let attributes = try? fileURL.resourceValues(forKeys: [.isRegularFileKey])
                    if attributes?.isRegularFile == true {
                        let destinationURL = destinationDirectory.appendingPathComponent(fileURL.lastPathComponent)
                        try? FileManager.default.moveItem(at: fileURL, to: destinationURL)
                        print("Moved \(fileURL) to \(destinationURL)")
                    }
                }
            }
        }
        
        private func isDataCaptureFile(_ fileURL: URL) -> Bool {
            return fileURL.pathExtension == "log"
        }
    }
}
