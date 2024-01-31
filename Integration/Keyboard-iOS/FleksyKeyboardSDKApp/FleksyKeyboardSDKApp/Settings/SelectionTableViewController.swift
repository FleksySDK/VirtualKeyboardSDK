//
//  SelectionTableViewController.swift
//  FleksyKeyboardSDKApp
//
//  Copyright © 2021 Thingthing,Ltd. All rights reserved.
//

import UIKit

protocol Selectable {
    var allowsSorting: Bool { get }
    var titleKey: String { get }
    var subtitleKey: String? { get }
    var items: [SelectionItem] { get }
    
    func itemsOrderUpdated(_ reorderedItems: [SelectionItem])
    func setSelected(_ item: SelectionItem)
    func getSelected() -> SelectionItem?
}

extension Selectable {
    /// Only need to implement if `allowsSorting` returns true.
    func itemsOrderUpdated(_ reorderedItems: [SelectionItem]) { }
}

class SelectionTableViewController: UITableViewController {
    
    private static let cellIdentifier = "CellIdentifier"
    
    var selectionData: Selectable? {
        didSet {
            reloadScreenInfo()
        }
    }
    
    private var allowsSorting: Bool {
        return selectionData?.allowsSorting ?? false
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
        navigationItem.rightBarButtonItem = allowsSorting ? editButtonItem : nil
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
            
            switch item.modificator {
            case .font(let optFont):
                let font = optFont ?? UIFont.preferredFont(forTextStyle: .body)
                let fontMetrics = UIFontMetrics(forTextStyle: .body)
                cell.textLabel?.font = fontMetrics.scaledFont(for: font)
            default:
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            }
            
            cell.selectionStyle = .none
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return (selectionData?.subtitleKey).map {
            let view = UIView()
            view.backgroundColor = .clear
            let label = UILabel()
            label.numberOfLines = 0
            label.font = UIFont.preferredFont(forTextStyle: .footnote)
            label.textColor = .systemGray
            label.text = NSLocalizedString($0, comment: "")

            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            let padding = tableView.layoutMargins.left
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
                label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
            
            return view
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return allowsSorting
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return allowsSorting
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let selectionSetting = selectionData, allowsSorting else {
            return
        }
        var items = selectionSetting.items
        let movedItem = items.remove(at: sourceIndexPath.row)
        items.insert(movedItem, at: destinationIndexPath.row)
        selectionSetting.itemsOrderUpdated(items)
    }
}
