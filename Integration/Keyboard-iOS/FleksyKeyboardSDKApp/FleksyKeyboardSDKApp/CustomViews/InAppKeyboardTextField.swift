//  InAppKeyboardTextField.swift
//  FleksyKeyboardSDKApp
//
//  Created on 10/1/23
//  
//

import UIKit

class InAppKeyboardTextField: UITextField {

    private lazy var keyboardViewController = KeyboardViewController()
    
    override var inputViewController: UIInputViewController? {
        return keyboardViewController
    }

}
