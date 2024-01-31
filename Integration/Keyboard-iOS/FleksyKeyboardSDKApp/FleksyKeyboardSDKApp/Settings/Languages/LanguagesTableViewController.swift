//
//  LanguagesTableViewController.swift
//  FleksyKeyboardSDKApp
//
//  Copyright © 2021 Thingthing,Ltd. All rights reserved.
//

import UIKit
import FleksyKeyboardSDK

class LanguagesTableViewController: UITableViewController {
    private enum Section: Int, CaseIterable {
        case installedLanguages = 0
        case nonInstalledLanguages = 1
        
        var sectionTitle: String {
            switch self {
            case .installedLanguages:
                return NSLocalizedString("Installed languages", comment: "")
            case .nonInstalledLanguages:
                return NSLocalizedString("Install other languages", comment: "")
            }
        }
        
        var sectionCaption: String? {
            switch self {
            case .installedLanguages:
                return NSLocalizedString("Swipe left or right on the keyboard's spacebar to change between installed languages", comment: "")
            case .nonInstalledLanguages:
                return nil
            }
        }
    }
    
    private static let keyboardLayoutSelectionSegueIdentifier = "KeyboardLayoutSelectionSegue"
    
    private lazy var languageManager = LanguagesManager.shared
    
    private lazy var spinner: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .large)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadInitialData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Self.keyboardLayoutSelectionSegueIdentifier:
            if let selectionVC = segue.destination as? SelectionTableViewController,
               let language = sender as? LanguageModel
            {
                let selectionData = KeyboardLayoutSelection(languageName: language.languageName, languageCode: language.code)
                selectionVC.selectionData = selectionData
            }
        default:
            break
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .installedLanguages:
            return languageManager.installedLanguages.count
        case .nonInstalledLanguages:
            return languageManager.nonInstalledLanguages.count
        case nil:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.identifier, for: indexPath) as? LanguageCell,
              let section = Section(rawValue: indexPath.section) else {
                  return UITableViewCell()
              }
        let language: LanguageModel = {
            switch section {
            case .installedLanguages:
                return languageManager.installedLanguages[indexPath.row]
            case .nonInstalledLanguages:
                return languageManager.nonInstalledLanguages[indexPath.row]
            }
        }()
        cell.loadLanguage(language)
        cell.delegate = self
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footerTitle = Section(rawValue: section)?.sectionCaption {
            let lb = UILabel()
            lb.font = .preferredFont(forTextStyle: .footnote)
            if #available(iOS 13, *) {
                lb.textColor = .secondaryLabel
            } else {
                lb.textColor = .lightText
            }
            lb.numberOfLines = 0
            lb.text = footerTitle
            let stackView = UIStackView(arrangedSubviews: [lb])
            stackView.layoutMargins = UIEdgeInsets(top: 10, left: tableView.layoutMargins.left, bottom: 10, right: tableView.layoutMargins.right)
            stackView.isLayoutMarginsRelativeArrangement = true
            return stackView
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let _ = Section(rawValue: section)?.sectionCaption {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedLanguage = getLanguage(at: indexPath)!
        switch selectedLanguage.downloadState {
        case .notDownloaded:
            languageManager.downloadLanguage(selectedLanguage)
        case .downloading:
            break
        case .downloaded, .installed:
            if languageManager.setCurrentLanguage(selectedLanguage) {
                tableView.reloadData()
            } else {
                //TODO: implement
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setup() {
        // Style & Views
        tableView.rowHeight = UITableView.automaticDimension
        registerCells()
        
        view.addSubview(spinner)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Configuration
        languageManager.delegate = self
    }
    
    private func loadInitialData() {
        spinner.startAnimating()
        languageManager.loadAvailableLanguages { [weak self] in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func getLanguage(at indexPath: IndexPath) -> LanguageModel? {
        return Section(rawValue: indexPath.section).map { section in
            switch section {
            case .installedLanguages:
                return languageManager.installedLanguages[indexPath.row]
            case .nonInstalledLanguages:
                return languageManager.nonInstalledLanguages[indexPath.row]
            }
        }
    }
    
    private func registerCells() {
        tableView.register(LanguageCell.nib, forCellReuseIdentifier: LanguageCell.identifier)
    }
}

extension LanguagesTableViewController: LanguagesManagerDelegate {
    func didFinishDownloadingLanguage(_ language: LanguageModel) {
        tableView.reloadData()
    }
    
    func didFailDownloadingLanguage(_ language: LanguageModel) {
        // Handle error case
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let language = getLanguage(at: indexPath),
           languageManager.canDeleteLanguage(language)
        {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let language = getLanguage(at: indexPath),
           languageManager.canDeleteLanguage(language)
        {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, view, handler in
                let success = self?.languageManager.deleteLanguage(language) ?? false
                if success {
                    tableView.reloadData()
                }
                handler(success)
            }
            let deleteImage = Constants.Images.trash
            deleteAction.image = deleteImage
            return UISwipeActionsConfiguration(actions: [deleteAction])
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete,
              let language = getLanguage(at: indexPath)
        else {
            return
        }
        if languageManager.deleteLanguage(language) {
            tableView.reloadData()
        } else {
            // Handle error case
        }
    }
}

extension LanguagesTableViewController: LanguageCellDelegate {
    func keyboardLayoutAction(cell: LanguageCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let language = getLanguage(at: indexPath)
        else {
            return
        }
        performSegue(withIdentifier: Self.keyboardLayoutSelectionSegueIdentifier, sender: language)
    }
}
