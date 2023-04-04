//
//  LanguageCell.swift
//  KeyboardOpenView
//
//  Copyright © 2023KeyboardOpenView Thingthing,Ltd. All rights reserved.
//

import UIKit

protocol LanguageCellDelegate: AnyObject {
    func keyboardLayoutAction(cell: LanguageCell)
}

class LanguageCell: UITableViewCell {
    
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    static var identifier: String { String(describing: self) }

    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var lbCode: UILabel!
    @IBOutlet private weak var btnLayout: UIButton!
    @IBOutlet private weak var imgIconAction: UIImageView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    private weak var language: LanguageModel?
    
    weak var delegate: LanguageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadStyle()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }

    func loadLanguage(_ language: LanguageModel) {
        self.language = language
        language.delegate = self
        lbTitle.text = language.languageName
        lbCode.text = language.code
        lbCode.isHidden = lbCode.text == lbTitle.text
        refreshForLanguageDownloadState(language, animated: false)
    }
        
    @IBAction func actionKeyboardLayout(_ sender: Any) {
        delegate?.keyboardLayoutAction(cell: self)
    }
    
    private func refreshForLanguageDownloadState(_ language: LanguageModel, animated: Bool) {
        switch language.downloadState {
        case .notDownloaded:
            btnLayout.isHidden = true
            imgIconAction.isHidden = false
            imgIconAction.image = Constants.Images.download
            progressView.isHidden = true
        case .downloading(progress: let progress):
            btnLayout.isHidden = true
            imgIconAction.isHidden = true
            progressView.isHidden = false
            progressView.setProgress(progress, animated: animated)
        case .downloaded:
            imgIconAction.isHidden = false
            imgIconAction.image = Constants.Images.plus
            btnLayout.isHidden = true
            progressView.isHidden = true
        case .installed(let currentLanguage, let keyboardLayout):
            imgIconAction.isHidden = !currentLanguage
            imgIconAction.image = Constants.Images.check
            btnLayout.isHidden = false
            refreshLayoutButton(title: keyboardLayout)
            progressView.isHidden = true
        }
    }
    
    private func loadStyle() {
        progressView.alpha = 0.4
        progressView.setProgress(0, animated: false)
    }
    
    private func refreshLayoutButton(title: String?) {
        let keyboardImage = Constants.Images.keyboard
        btnLayout.setTitle(title ?? "", for: .normal)
        btnLayout.setImage(keyboardImage, for: .normal)
        if #available(iOS 15, *) {
            btnLayout.configuration?.imagePadding = 10
        }
    }
    
    private func resetView() {
        progressView.setProgress(0, animated: false)
        if language?.delegate === self {
            language?.delegate = nil
        }
    }
}

extension LanguageCell: LanguageModelDelegate {
    func downloadStateDidChange(_ language: LanguageModel) {
        refreshForLanguageDownloadState(language, animated: true)
    }
}
