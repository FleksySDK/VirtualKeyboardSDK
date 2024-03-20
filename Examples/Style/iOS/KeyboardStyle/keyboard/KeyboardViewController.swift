//
//  KeyboardViewController.swift
//  keyboard
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//  Licensed under the MIT license. See LICENSE file in the project root for details
//

import UIKit
import FleksyKeyboardSDK

// MARK: - KeyboardViewController

class KeyboardViewController: FKKeyboardViewController {
    
    // StyleConfiguration change
    private var keyboardStyle: KeyboardStyle = .light
    
    // MARK: View Controller life cycle
    
    /// - Important: Every time the keyboard appears it calls in this order: ``viewDidLoad`` -> ``viewWillAppear`` -> ``viewDidAppear``.
    /// Keyboard extensions don't reuse the view, which means that, in every appearance, we recreate what's inside ``viewDidLoad``.
    /// This behaviour is different from the normal iOS ViewController.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func createConfiguration() -> KeyboardConfiguration {
        // Examples on configuration at startup
        let licenseConfig = LicenseConfiguration(licenseKey: "your-license-key", licenseSecret: "your-license-secret")
        let styleConfig = keyboardStyle.getStyleConfiguration()
        return KeyboardConfiguration(style:styleConfig, license: licenseConfig)
    }
    
    //
    // Topbar Icon Example on different types of topbar icons
    //
    enum IconTopBar {
        case appIcon
        case leadingView
        case trailingView
    }
    
    //
    // @Please, choose any of the three types of IconTopBar to test any of the three different types of icons.
    // When the view is used, leading or trailing, you should implement the button and action if you want to receive
    // the action.
    //
    // Note: overriding leadingTopBarView overrides the usage of appIcon, so, if you only want to use the appIcon, only override the appIcon or return super.leadingTopBarView when overriding the leadingTopBarView.
    //
    let iconPosition = IconTopBar.trailingView
    
    override var appIcon: UIImage? {
        guard iconPosition == .appIcon else {
            return super.appIcon
        }
        return UIImage(named: "IconOrange")
    }
    
    override var leadingTopBarView: UIView? {
        guard iconPosition == .leadingView else {
            return super.leadingTopBarView
        }
        let iconViewLeading = UIView()
        iconViewLeading.translatesAutoresizingMaskIntoConstraints = false
        let button = UIButton(type:UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "IconBlue"), for: UIControl.State.normal)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(leadingButton), for: .touchUpInside)
        
        iconViewLeading.addSubview(button)
        NSLayoutConstraint.activate([
            iconViewLeading.widthAnchor.constraint(equalToConstant: 42),
            button.widthAnchor.constraint(equalToConstant: 38),
            button.centerYAnchor.constraint(equalTo: iconViewLeading.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: iconViewLeading.centerXAnchor),
        ])
        
        return iconViewLeading
    }
    
    
    override var trailingTopBarView: UIView? {
        guard iconPosition == .trailingView else {
            return super.trailingTopBarView
        }
        let iconViewTrailing = UIView()
        iconViewTrailing.translatesAutoresizingMaskIntoConstraints = false
        let button = UIButton(type:UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "IconBlack"), for: UIControl.State.normal)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(trailingButton), for: .touchUpInside)
        
        iconViewTrailing.addSubview(button)
        NSLayoutConstraint.activate([
            iconViewTrailing.widthAnchor.constraint(equalToConstant: 42),
            button.widthAnchor.constraint(equalToConstant: 38),
            button.centerYAnchor.constraint(equalTo: iconViewTrailing.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: iconViewTrailing.centerXAnchor),
        ])
        return iconViewTrailing
        
    }
    
    override func triggerOpenApp() {
        print("appIcon")
    }
    @objc func leadingButton(sender: UIButton!) {
        print("leadingButton")
        
        print("Change theme on the fly")
        keyboardStyle = keyboardStyle.next()
        reloadConfiguration()
    }
    @objc func trailingButton(sender: UIButton!) {
        print("trailingButton")
        
        print("Change theme on the fly")
        keyboardStyle = keyboardStyle.next()
        reloadConfiguration()
    }
}
