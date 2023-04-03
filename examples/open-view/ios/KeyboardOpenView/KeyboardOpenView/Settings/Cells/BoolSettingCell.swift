//
//  BoolSettingCell.swift
//  KeyboardOpenView
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//

import UIKit

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
    
    private var setting: BoolSetting? {
        didSet {
            self.reloadContent()
        }
    }

    func loadSetting(_ setting: BoolSetting) {
        self.setting = setting
    }
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        setting?.set(value: sender.isOn)
    }
    
    private func reloadContent() {
        guard let setting = self.setting else { return }
        
        lbTitle.text = NSLocalizedString(setting.titleKey, comment: "")
        lbSubtitle.text = setting.subtitleKey.map {
            NSLocalizedString($0, comment: "")
        }
        lbSubtitle.isHidden = lbSubtitle.text?.isEmpty ?? true
        switchSetting.isOn = setting.get()
    }
    
}
