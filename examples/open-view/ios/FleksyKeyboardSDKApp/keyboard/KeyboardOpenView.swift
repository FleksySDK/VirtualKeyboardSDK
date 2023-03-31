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
/// Example on how to add a View on top of the keyboard
/// This can be cusomized to your own needs
///
class KeyboardOpenView : KeyboardApp{
    
    let appId = "someId.example" // Static ID used to call this View from the keyboardViewController
    var configuration: AppConfiguration?
    var listener: AppListener?
    var exampleView: UIView?
    
    func initialize(listener: AppListener, configuration: AppConfiguration) {
        self.listener = listener
        self.configuration = configuration
        self.exampleView = UIView()
    }
    
    func dispose() {
        self.exampleView = nil
    }
    
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
    
    /// This is gonna be called automatically by the system when you close the View.
    func close() {
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
        self.exampleView?.backgroundColor = UIColor.init(red: 37.0/255.0, green: 150.0/255.0, blue: 190.0/255.0, alpha: 1.0)//theme.background
        
        // Add a simple close button
        let btnClose = UIButton()
        btnClose.backgroundColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        btnClose.setTitleColor(UIColor.init(red: 185.0/255.0, green: 117.0/255.0, blue: 85.0/255.0, alpha: 1.0), for: .normal)
        btnClose.setTitle("Hide", for: .normal)
        btnClose.layer.cornerRadius = 3.0
        btnClose.layer.shadowColor = UIColor.init(red: 185.0/255.0, green: 117.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
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
        
        let text = UILabel()
        text.textAlignment = .center
        text.textColor = UIColor.white
        text.text = "Customisable View 👀"
        text.translatesAutoresizingMaskIntoConstraints = false
        self.exampleView?.addSubview(text)
        self.exampleView?.addConstraints([NSLayoutConstraint(item: text, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.exampleView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0),NSLayoutConstraint(item: text, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.exampleView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0),NSLayoutConstraint(item: text, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 240),NSLayoutConstraint(item: text, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)])
        
        
        // Add anything else here.
        
        return exampleView
    }
}
