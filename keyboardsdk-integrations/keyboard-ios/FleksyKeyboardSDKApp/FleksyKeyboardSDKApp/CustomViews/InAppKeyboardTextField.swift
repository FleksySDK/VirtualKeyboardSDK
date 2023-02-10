//  InAppKeyboardTextField.swift
//  FleksyKeyboardSDKApp
//
//  Created on 10/1/23
//  
//

import UIKit

class InAppKeyboardTextField: UITextField {

    private let keyboardViewController = KeyboardViewController()
    
    override var inputViewController: UIInputViewController? {
        return keyboardViewController
    }

}
