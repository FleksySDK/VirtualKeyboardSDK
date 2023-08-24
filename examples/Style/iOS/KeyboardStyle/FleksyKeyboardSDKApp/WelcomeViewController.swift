//
//  WelcomeViewController.swift
//  FleksyKeyboardSDKApp
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
import FleksyKeyboardSDK

class WelcomeViewController: UITableViewController {
    
    private static let subtitleCellReuseIdentifier = "SubtitleSettingsCellId"
    private static let rightDetailCellReuseIdentifier = "RightDetailSettingsCellId"
    
    private static var fleksyKeyboardAdded: Bool {
        return FleksyExtensionSetupStatus.isAddedToSettingsKeyboardExtension(withBundleId: Constants.App.keyboardExtensionBundleId)
    }
    
    private struct Item {
        let titleKey: String
        let detailKey: String?
        let type: ItemType
        
        init(titleKey: String, subtitleKey: String? = nil, type: ItemType) {
            self.titleKey = titleKey
            self.detailKey = subtitleKey
            self.type = type
        }
    }
    
    enum ItemAction {
        case segue(identifier: String)
        case openURL(url: URL)
    }
    
    private enum ItemType {
        case link(path: String)
        case info
        
        var action: ItemAction? {
            switch self {
            case .link(let path):
                guard let url = URL(string: path) else {
                    return nil
                }
                return .openURL(url: url)
            case .info:
                return nil
            }
        }
        
        var cellIdentifier: String {
            switch self {
            case .info:
                return WelcomeViewController.rightDetailCellReuseIdentifier
            default:
                return WelcomeViewController.subtitleCellReuseIdentifier
            }
        }
    }
    
    private struct Section {
        let titleKey: String
        let items: [Item]
        
        init(titleKey: String, items: [Item?]) {
            self.titleKey = titleKey
            self.items = items.compactMap { $0 }
        }
    }
    
    private lazy var sections: [Section] = []
    
    private static func getSections() -> [Section] {
        return [
            Section(titleKey: "Information", items: [
                Item(titleKey: "App version",
                     subtitleKey: Constants.App.versionAndBuild,
                     type: .info),
                Item(titleKey: "FleksyKeyboardSDK version",
                     subtitleKey: Constants.App.keyboardSDKVersionAndBuild,
                     type: .info),
                Item(titleKey: "Keyboard status",
                     subtitleKey: fleksyKeyboardAdded ? "Installed" : "Not installed",
                     type: fleksyKeyboardAdded ? .info : .link(path: UIApplication.openSettingsURLString))
            ])
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Develop with Fleksy!", comment: "")
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let item = sender as? Item {
            segue.destination.title = NSLocalizedString(item.titleKey, comment: "")
        }
    }
    
    @objc func appDidBecomeActive(_ notification: Notification) {
        reloadData()
    }
    
    // MARK: - Private functions
    
    private func reloadData() {
        sections = Self.getSections()
        tableView.reloadData()
    }
    
    // MARK: - UITableViewControllerDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.type.cellIdentifier)!
        cell.textLabel?.text = NSLocalizedString(item.titleKey, comment: "")
        cell.detailTextLabel?.text = item.detailKey.map {
            NSLocalizedString($0, comment: "")
        }
        cell.accessoryType = item.type.action == nil ? .none : .disclosureIndicator
        return cell
    }
    
    // MARK: - UITableViewControllerDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = sections[indexPath.section].items[indexPath.row]
        switch item.type.action {
        case .none:
            return
        case .segue(identifier: let identifier):
            performSegue(withIdentifier: identifier, sender: item)
        case .openURL(url: let url):
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        NSLocalizedString(sections[section].titleKey, comment: "")
    }
}
