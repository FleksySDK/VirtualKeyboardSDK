//
//  KeyboardOpenView.swift
//  keyboard
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
import FleksyAppsCore

///
/// Example on how to add a View over (i.e. covering) the keyboard
/// This can be cusomized to your own needs
///
class KeyboardOpenViewCustom : KeyboardApp{
    
    let appId = "someId.example" // Static ID used to call this View from the keyboardViewController
    var configuration: AppConfiguration?
    var listener: AppListener?
    var exampleView: UIView?
    
    func initialize(listener: AppListener, configuration: AppConfiguration) {
        self.listener = listener
        self.configuration = configuration
    }
    
    func dispose() {
        listener = nil
        configuration = nil
    }
    
    var defaultViewMode: KeyboardAppViewMode {
        .fullCover() // Shows the view over the keyboard, i.e. covering it.
    }
    
    ///
    /// From the keyboardViewController you can decide when to call this method,
    /// which will show the view that you send here.
    ///
    func open(viewMode: KeyboardAppViewMode, theme: AppTheme) -> UIView? {
        if exampleView == nil {
            createYourOwnView()
        }
        return exampleView
    }
    
    /// This is gonna be called automatically by the system when you close the View.
    func close() {
        // Free all references created from the open()
        exampleView = nil
    }
    
    func onThemeChanged(_ theme: AppTheme) {
        // Change the color of the theme if you want
        //
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
        exampleView.backgroundColor = UIColor.init(red: 37.0/255.0, green: 150.0/255.0, blue: 190.0/255.0, alpha: 1.0)//theme.background
        
        // Add a simple close button
        let btnClose = UIButton()
        btnClose.backgroundColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        btnClose.setTitleColor(UIColor.init(red: 185.0/255.0, green: 117.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
        btnClose.setTitle("Hide", for: .normal)
        btnClose.layer.cornerRadius = 3.0
        btnClose.layer.shadowColor = UIColor.init(red: 185.0/255.0, green: 117.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        btnClose.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        
        exampleView.addSubview(btnClose)
        
        // Add constraints for cosmetics
        NSLayoutConstraint.activate([
            btnClose.trailingAnchor.constraint(equalTo: exampleView.leadingAnchor, constant: -5),
            btnClose.topAnchor.constraint(equalTo: exampleView.topAnchor, constant: 5),
            btnClose.widthAnchor.constraint(equalToConstant: 85),
            btnClose.heightAnchor.constraint(equalToConstant: 25)
        ])

        btnClose.addTarget(self, action: #selector(hideMyself), for: .touchUpInside)
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "Customisable View 👀"
        label.translatesAutoresizingMaskIntoConstraints = false
        exampleView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: exampleView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: exampleView.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 240),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Add anything else here.
        self.exampleView = exampleView
    }
}
