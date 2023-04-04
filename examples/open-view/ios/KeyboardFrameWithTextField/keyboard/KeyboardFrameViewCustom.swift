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
class KeyboardFrameViewCustom : KeyboardApp, AppTextFieldDelegate{
    
    let appId = "someId.example" // Static ID used to call this View from the keyboardViewController
    var configuration: AppConfiguration?
    var listener: AppListener?
    var exampleView: UIView?
    var text: UILabel?
    
    // Configuration of the TextField
    let placeholder = "Add your placeholder here"
    let initialText = ""
    let returnKeyType = UIReturnKeyType.go
    
    func initialize(listener: AppListener, configuration: AppConfiguration) {
        self.listener = listener
        self.configuration = configuration
        self.exampleView = UIView()
    }
    
    func dispose() {
        self.listener = nil
        self.configuration = nil
        self.exampleView = nil
        self.text = nil
    }
    
    /// The view mode for the FleksyApp when opened from the carousel.
    ///
    /// Override this property if your FleksyApp needs a different initial view mode.
    open var defaultViewMode: KeyboardAppViewMode { .frame(barMode: .appTextField(delegate: self), height: .default) }
    
    ///
    /// From the keyboardViewController you can decide when to call this method,
    /// which will show the view that you send here.
    ///
    func open(viewMode: KeyboardAppViewMode, theme: AppTheme) -> UIView? {
        return createYourOwnView()
    }
    
    // Handle the button
    // In this case we consider interesting to hide the current view.
    @MainActor @objc func handleClose(){
        self.exampleView?.removeFromSuperview()
        hideMyself()
    }
    
    @MainActor @objc func handleFullCover(){
        self.text?.text = ""
        self.listener?.show(mode: .fullCover)
    }
    
    /// This is gonna be called automatically by the system when you close the View.
    func close() {
        self.text?.text = ""
        // Free all references created from the open()
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
    @MainActor func hideMyself(){
        self.listener?.hide()
    }
    
    
    //
    // Create your own view to add on top of the keyboard
    //
    func createYourOwnView() -> UIView?{
        
        // Configure the example View
        self.exampleView?.backgroundColor = UIColor.init(red: 227.0/255.0, green: 188.0/255.0, blue: 45.0/255.0, alpha: 1.0)//theme.background
        
        // Add a simple close button
        let btnClose = UIButton()
        btnClose.backgroundColor = UIColor.init(red: 245.0/255.0, green: 244.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        btnClose.setTitleColor(UIColor.init(red: 138.0/255.0, green: 115.0/255.0, blue: 23.0/255.0, alpha: 1.0), for: .normal)
        btnClose.setTitle("Hide", for: .normal)
        btnClose.layer.cornerRadius = 3.0
        btnClose.layer.shadowColor = UIColor.init(red: 138.0/255.0, green: 115.0/255.0, blue: 23.0/255.0, alpha: 1.0).cgColor
        btnClose.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        
        self.exampleView?.addSubview(btnClose)
        
        // Add constraints for cosmetics
        let horizontalConstraint = NSLayoutConstraint(item: btnClose, attribute: NSLayoutConstraint.Attribute.trailingMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.exampleView, attribute: NSLayoutConstraint.Attribute.trailingMargin, multiplier: 1, constant: -5)
        let verticalConstraint = NSLayoutConstraint(item: btnClose, attribute: NSLayoutConstraint.Attribute.topMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.exampleView, attribute: NSLayoutConstraint.Attribute.topMargin, multiplier: 1, constant: 5)
         let widthConstraint = NSLayoutConstraint(item: btnClose, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 85)
         let heightConstraint = NSLayoutConstraint(item: btnClose, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 25)
        self.exampleView?.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])

        btnClose.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        
        // Add a button for changing from frame to fullcover
        let btnFullCover = UIButton()
        btnFullCover.backgroundColor = UIColor.init(red: 245.0/255.0, green: 244.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        btnFullCover.setTitleColor(UIColor.init(red: 185.0/255.0, green: 117.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)

        
        btnFullCover.setTitle("FullCover", for: .normal)
        btnFullCover.layer.cornerRadius = 3.0
        btnFullCover.layer.shadowColor = UIColor.init(red: 185.0/255.0, green: 117.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        btnFullCover.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        btnFullCover.translatesAutoresizingMaskIntoConstraints = false
        
        self.exampleView?.addSubview(btnFullCover)
        
        // Add constraints for cosmetics
        self.exampleView?.addConstraints([NSLayoutConstraint(item: btnFullCover, attribute: NSLayoutConstraint.Attribute.trailingMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.exampleView, attribute: NSLayoutConstraint.Attribute.trailingMargin, multiplier: 1, constant: -5), NSLayoutConstraint(item: btnFullCover, attribute: NSLayoutConstraint.Attribute.bottomMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.exampleView, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: -5), NSLayoutConstraint(item: btnFullCover, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 85), NSLayoutConstraint(item: btnFullCover, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 25)])

        btnFullCover.addTarget(self, action: #selector(handleFullCover), for: .touchUpInside)
        
        self.text = UILabel()
        self.text?.textAlignment = .center
        self.text?.textColor = UIColor.white
        self.text?.text = "Frame View 👀 - Type your text"
        self.text?.translatesAutoresizingMaskIntoConstraints = false
        self.exampleView?.addSubview(self.text!)
        self.exampleView?.addConstraints([NSLayoutConstraint(item: self.text!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.exampleView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0),NSLayoutConstraint(item: self.text!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.exampleView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0),NSLayoutConstraint(item: self.text!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300),NSLayoutConstraint(item: self.text!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)])
        
        // Add anything else here.
        
        return exampleView
    }
    
    
    func onAppIconAction() {
        
    }
    
    func onCloseAction() {
        
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
        self.text?.text = text
    }
}
