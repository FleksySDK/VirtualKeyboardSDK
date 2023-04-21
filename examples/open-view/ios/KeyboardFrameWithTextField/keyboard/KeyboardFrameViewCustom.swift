//
//  KeyboardFrameViewCustom.swift
//  keyboard
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
import FleksyAppsCore

///
/// Example on how to add a View on top of the keyboard
/// This can be cusomized to your own needs
///
class KeyboardFrameViewCustom : KeyboardApp, AppTextFieldDelegate {
    
    let appId = "someId.example" // Static ID used to call this View from the keyboardViewController
    var configuration: AppConfiguration?
    var listener: AppListener?
    var exampleView: UIView?
    var label: UILabel?
    
    // Configuration of the TextField
    let placeholder = "Add your placeholder here"
    let initialText = ""
    let returnKeyType = UIReturnKeyType.go
    
    func initialize(listener: AppListener, configuration: AppConfiguration) {
        self.listener = listener
        self.configuration = configuration
    }
    
    func dispose() {
        listener = nil
        configuration = nil
    }
    
    /// The view mode for the FleksyApp when opened from the carousel.
    ///
    /// Override this property if your FleksyApp needs a different initial view mode.
    open var defaultViewMode: KeyboardAppViewMode {
        .frame(barMode: .appTextField(delegate: self), height: .default)
    }
    
    ///
    /// From the keyboardViewController you can decide when to call this method,
    /// which will show the view that you send here.
    ///
    func open(viewMode: KeyboardAppViewMode, theme: AppTheme) -> UIView? {
        if exampleView == nil || label == nil {
            createYourOwnView()
        }
        return exampleView
    }
    
    @MainActor @objc func handleFullCover() {
        label?.text = nil
        listener?.show(mode: .fullCover)
    }
    
    /// This is gonna be called automatically by the system when you close the View.
    func close() {
        // Free all references created from the open()
        exampleView = nil
        label = nil
    }
    
    func onThemeChanged(_ theme: AppTheme) {
        // Change the color of the theme if you want
    }
    
    func appIcon() -> UIImage? {
        // Add any image if you want.
        return UIImage(systemName: "questionmark")
    }
    
    ///
    /// Configure this to hide itself.
    /// Normally, you might add a button in the view to trigger this hide() action. After this action, the system itself will call close() method.
    ///
    @MainActor @objc func hideMyself() {
        listener?.hide()
    }
    
    
    //
    // Create your own view to add on top of the keyboard
    //
    func createYourOwnView() {
        
        let exampleView = UIView()
        
        // Configure the example View
        exampleView.backgroundColor = UIColor.init(red: 227.0/255.0, green: 188.0/255.0, blue: 45.0/255.0, alpha: 1.0)//theme.background
        
        // Add a simple close button
        let btnClose = UIButton()
        btnClose.backgroundColor = UIColor.init(red: 245.0/255.0, green: 244.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        btnClose.setTitleColor(UIColor.init(red: 138.0/255.0, green: 115.0/255.0, blue: 23.0/255.0, alpha: 1.0), for: .normal)
        btnClose.setTitle("Hide", for: .normal)
        btnClose.layer.cornerRadius = 3.0
        btnClose.layer.shadowColor = UIColor.init(red: 138.0/255.0, green: 115.0/255.0, blue: 23.0/255.0, alpha: 1.0).cgColor
        btnClose.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        
        exampleView.addSubview(btnClose)
        
        // Add constraints for cosmetics
        NSLayoutConstraint.activate([
            btnClose.trailingAnchor.constraint(equalTo: exampleView.trailingAnchor, constant: -5),
            btnClose.topAnchor.constraint(equalTo: exampleView.topAnchor, constant: 5),
            btnClose.widthAnchor.constraint(equalToConstant: 85),
            btnClose.heightAnchor.constraint(equalToConstant: 25)
        ])

        btnClose.addTarget(self, action: #selector(hideMyself), for: .touchUpInside)
        
        // Add a button for changing from frame to fullcover
        let btnFullCover = UIButton()
        btnFullCover.backgroundColor = UIColor.init(red: 245.0/255.0, green: 244.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        btnFullCover.setTitleColor(UIColor.init(red: 185.0/255.0, green: 117.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)

        
        btnFullCover.setTitle("FullCover", for: .normal)
        btnFullCover.layer.cornerRadius = 3.0
        btnFullCover.layer.shadowColor = UIColor.init(red: 185.0/255.0, green: 117.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        btnFullCover.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        btnFullCover.translatesAutoresizingMaskIntoConstraints = false
        
        exampleView.addSubview(btnFullCover)
        
        // Add constraints for cosmetics
        NSLayoutConstraint.activate([
            btnFullCover.trailingAnchor.constraint(equalTo: exampleView.trailingAnchor, constant: -5),
            btnFullCover.bottomAnchor.constraint(equalTo: exampleView.bottomAnchor, constant: -5),
            btnFullCover.widthAnchor.constraint(equalToConstant: 85),
            btnFullCover.heightAnchor.constraint(equalToConstant: 25)
        ])

        btnFullCover.addTarget(self, action: #selector(handleFullCover), for: .touchUpInside)
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Frame View 👀 - Type your text"
        label.translatesAutoresizingMaskIntoConstraints = false
        exampleView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: exampleView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: exampleView.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        // Add anything else here.
        
        self.exampleView = exampleView
        self.label = label
    }
    
    /// When the user presses the icon button next to the keyboard text field
    /// we receive this call
    func onAppIconAction() {
        
    }
    
    /// When the user presses the X button next to the keyboard text field
    /// while the text is empty, we receive this call.
    func onCloseAction() {
        hideMyself()
    }
    
    ///
    /// While the user is typing we keep receiving the text that it's typing
    ///
    func onTextDidChange(_ text: String?) {
        
    }
    
    ///
    /// When the user presses the "enter" key we receive the text and execute what we want
    /// In this simple use case the text will appear on the frame view
    ///
    func onReturnKeyAction(_ text: String?) {
        label?.text = text
    }
}
