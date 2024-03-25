//
//  ViewController.swift
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var btnLight: UIButton!
    @IBOutlet weak var btnBlue: UIButton!
    
    private var customInputViewController: KeyboardViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield.text = nil
        textfield.placeholder = "Try the secure keyboard..."
        btnLight.setTitle("", for: UIControl.State.normal)
        btnBlue.setTitle("", for: UIControl.State.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setKeyboardStyle(.light, button: btnLight)
        textfield.becomeFirstResponder()
    }
    
    func initKeyboard(style: KeyboardStyle) {
        customInputViewController = KeyboardViewController(style: style)
        textfield.inputView = customInputViewController?.inputView
    }
    
    // Color Configuration
    //
    @IBAction func actionUseLightStyle(_ sender: UIButton) {
        setKeyboardStyle(.light, button: sender)
    }
    
    @IBAction func actionUseBlueStyle(_ sender: UIButton) {
        setKeyboardStyle(.blue, button: sender)
    }
    
    private func setKeyboardStyle(_ style: KeyboardStyle, button: UIButton) {
        guard customInputViewController?.style != style else {
            return
        }
        
        resetSelection()
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 3.0
        
        textfield.resignFirstResponder()
        initKeyboard(style: style)
        textfield.becomeFirstResponder()
    }
    
    private func resetSelection() {
        btnLight.layer.borderWidth = 0.0
        btnBlue.layer.borderWidth = 0.0
    }
}
