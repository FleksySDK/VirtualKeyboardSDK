//
//  CustomTextField.swift
//  FleksyCoreSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setup() {
        self.clearButtonMode = .always
        
        self.font = .systemFont(ofSize: 18)
        self.autocorrectionType = .no
        
        let paddingView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 16))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.rightView = paddingView
        self.rightViewMode = .always
        
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
}
