//
//  SelectionTableViewController.swift
//  FleksyKeyboardSDKApp
//
//  Created by Antonio Jesús Pallares Martín on 22/10/21.
//  Copyright © 2021 Thingthing,Ltd. All rights reserved.
//

import UIKit

protocol Selectable {
    var titleKey: String { get }
    var items: [SelectionItem] { get }
    
    func setSelected(_ item: SelectionItem)
    func getSelected() -> SelectionItem?
}

class SelectionTableViewController: UITableViewController {
    
    private static let cellIdentifier = "CellIdentifier"
    
    var selectionData: Selectable? {
        didSet {
            reloadScreenInfo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    // MARK: - Private functions
    
    private func reloadScreenInfo() {
        title = (selectionData?.titleKey).map {
            NSLocalizedString($0, comment: "")
        }
        isEditing = false
        tableView.reloadData()
    }
    
    private func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionData?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        if let selectionSetting = selectionData {
            let item = selectionSetting.items[indexPath.row]
            cell.textLabel?.text = NSLocalizedString(item.titleKey, comment: "")
            cell.detailTextLabel?.text = item.subtitleKey.map {
                NSLocalizedString($0, comment: "")
            }
            if item.value == selectionSetting.getSelected()?.value {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectionSetting = selectionData else {
            return
        }
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let selectedItem = selectionSetting.items[indexPath.row]
        selectionSetting.setSelected(selectedItem)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }    
}
