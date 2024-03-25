//
//  ViewController.swift
//
//  Copyright © 2023 Thingthing,Ltd. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var textfield: UITextField!
    @IBOutlet weak var btnStandard: UIButton!
    @IBOutlet weak var btnBlue: UIButton!
    
    private var customInputViewController: KeyboardViewController?
    
    private let themeStandard = 0
    private let themeColorBlue = 1
    private var currentTheme = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        textfield.text = nil
        textfield.placeholder = "Try the secure keyboard..."
        
        initKeyboard(selection: currentTheme)
        
        textfield.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetSelection()
        
        btnStandard.layer.borderWidth = 2.0
        btnStandard.layer.borderColor = UIColor(red: 179.0/255.0, green: 184.0/255.0, blue: 192.0/255.0, alpha: 1.0).cgColor 
        btnStandard.layer.cornerRadius = 3.0
    }
    
    func initKeyboard(selection: Int){
        customInputViewController = nil
        
        customInputViewController = KeyboardViewController()
        customInputViewController?.setConfiguration(themeSelection: selection)
        textfield.inputView = customInputViewController?.inputView
    }
    
    // Color Configuration
    //
    @IBAction func onBtnStandard(_ sender: Any) {
        
        if(currentTheme == themeStandard){
            return
        }
        resetSelection()
        
        btnStandard.layer.borderWidth = 2.0
        btnStandard.layer.borderColor = UIColor(red: 179.0/255.0, green: 184.0/255.0, blue: 192.0/255.0, alpha: 1.0).cgColor
        btnStandard.layer.cornerRadius = 3.0
        
        textfield.resignFirstResponder()
        currentTheme = themeStandard
        initKeyboard(selection: currentTheme)
        textfield.becomeFirstResponder()
    }
    
    @IBAction func onBtnBlue(_ sender: Any) {
        if(currentTheme == themeColorBlue){
            return
        }
        resetSelection()

        btnBlue.layer.borderWidth = 2.0
        btnBlue.layer.borderColor = UIColor(red: 70.0/255.0, green: 182.0/255.0, blue: 254.0/255.0, alpha: 1.0).cgColor
        btnBlue.layer.cornerRadius = 3.0
        
        textfield.resignFirstResponder()
        currentTheme = themeColorBlue
        initKeyboard(selection: currentTheme)
        textfield.becomeFirstResponder()
    }
    
    func resetSelection(){
        btnStandard.layer.borderWidth = 0.0
        btnStandard.setTitle("", for: UIControl.State.normal)
        
        btnBlue.setTitle("", for: UIControl.State.normal)
        btnBlue.layer.borderWidth = 0.0
    }
}
