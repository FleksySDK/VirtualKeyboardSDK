//
//  SettingsTableViewController.swift
//  FleksyKeyboardSDKApp
//
//  Copyright © 2021 Thingthing,Ltd. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    private static let selectionSettingSegueIdentifier = "SelectionSettingSegue"

    var settings: [SettingModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData() // SelectionSettings might be changed after coming back
    }

    private func registerCells() {
        tableView.register(BoolSettingCell.nib, forCellReuseIdentifier: BoolSettingCell.identifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (sender, segue.destination) {
        case (let selectionSetting as SelectionSetting, let selectionSettingVC as SelectionTableViewController):
            selectionSettingVC.selectionData = selectionSetting
        default:
            break
        }
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settings[indexPath.row]
        switch setting {
        case .bool(let boolSetting):
            guard let boolSettingCell = tableView.dequeueReusableCell(withIdentifier: BoolSettingCell.identifier) as? BoolSettingCell else {
                return UITableViewCell()
            }
            boolSettingCell.selectionStyle = .none
            boolSettingCell.loadSetting(boolSetting)
            boolSettingCell.accessibilityIdentifier = boolSetting.accessibilityPrefix + Constants.Accessibility.ComponentSuffix.view
            return boolSettingCell
        case .selection(let selectionSetting):
            let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
            let cell = dequeuedCell ?? UITableViewCell(style: .subtitle, reuseIdentifier: String(describing: UITableViewCell.self))
            cell.textLabel?.text = NSLocalizedString(selectionSetting.titleKey, comment: "")
            cell.detailTextLabel?.text = selectionSetting.subtitleKey.map {
                NSLocalizedString($0, comment: "")
            }
            cell.accessoryType = .disclosureIndicator
            cell.accessibilityIdentifier = selectionSetting.accessibilityPrefix + Constants.Accessibility.ComponentSuffix.button
            cell.selectionStyle = .default
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.row]
        switch setting {
        case .bool:
            break
        case .selection(let selectionSetting):
            performSegue(withIdentifier: Self.selectionSettingSegueIdentifier, sender: selectionSetting)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
