//
//  BoolSettingCell.swift
//  FleksyKeyboardSDKApp
//
//  Created by Antonio Jesús Pallares Martín on 20/10/21.
//  Copyright © 2021 Thingthing,Ltd. All rights reserved.
//

import UIKit

protocol BoolSettingCellDelegate: SettingsTableViewController {
    func updateRelatedCells(for parentKey: String)
}

class BoolSettingCell: UITableViewCell {
    
    static var identifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var lbSubtitle: UILabel!
    @IBOutlet private weak var switchSetting: UISwitch!
    
    weak var delegate: (BoolSettingCellDelegate)?
    
    private var setting: BoolSetting? {
        didSet {
            self.reloadContent()
        }
    }

    func loadSetting(_ setting: BoolSetting) {
        self.setting = setting
    }
    
    func refreshIfNeeded(for parentKey: String) -> Bool {
        guard let setting = self.setting else { return false }
        let isRelated = setting.relations
            .filter({ $0.isDependant })
            .compactMap({ $0.key })
            .contains(parentKey)
        return isRelated
    }
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        setting?.set(value: sender.isOn)
        guard let setting = self.setting else { return }
        sender.isOn = setting.get()
        guard let delegate = self.delegate else { return }
        delegate.updateRelatedCells(for: setting.settingKey)
    }
    
    private func reloadContent() {
        guard let setting = self.setting else { return }
        
        lbTitle.text = NSLocalizedString(setting.titleKey, comment: "")
        lbSubtitle.text = setting.subtitleKey.map {
            NSLocalizedString($0, comment: "")
        }
        lbSubtitle.isHidden = lbSubtitle.text?.isEmpty ?? true
        switchSetting.isOn = setting.get()
        
        accessibilityIdentifier = setting.accessibilityPrefix + Constants.Accessibility.ComponentSuffix.view
        switchSetting.accessibilityIdentifier = setting.accessibilityPrefix + Constants.Accessibility.ComponentSuffix.switchControl
    }
    
}
