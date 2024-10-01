//
//  KeyboardFrameViewCustom.swift
//  keyboard
//
//  Copyright © 2024 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
import FleksyAppsCore

///
/// Example on how to add a View on top of the keyboard
/// This can be cusomized to your own needs
///
class KeyboardFrameViewCustom : KeyboardApp, AppTextFieldDelegate {
    
    static let appId = "someId.example" // Static ID used to call this View from the keyboardViewController
    
    var appId: String { Self.appId }
    var configuration: AppConfiguration?
    var listener: AppListener?
    var exampleView: UIView?
    var label: UILabel?
        
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
        .frame(barMode: .default, height: .automatic)
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
        // This image is used only:
        // 1. In the apps carousel
        // 2. When using TopBarMode.appTextField.
        // Therefore, it can be nil for
        return nil
    }
    
    //
    // Create your own view to add on top of the keyboard
    //
    func createYourOwnView() {
        
        let exampleView = UIView()
        
        // Configure the example View
        exampleView.backgroundColor = .darkGray
                
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Frame View that appears as soon as the keyboard opens"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        exampleView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: exampleView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: exampleView.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(lessThanOrEqualTo: exampleView.heightAnchor),
            exampleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
        
        self.exampleView = exampleView
        self.label = label
    }
    
    func onCloseAction() {
        // Only applies when using TopBarMode.appTextField
    }
}
