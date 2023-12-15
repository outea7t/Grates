//
//  CustomTextField.swift
//  Grates
//
//  Created by Out East on 07.12.2023.
//

import Foundation
import UIKit

class RegisterTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 40)
    init(placeholder: String) {
        super.init(frame: .zero)
        self.setupTextField(placeholder: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    private func setupTextField(placeholder: String) {
        self.textColor = #colorLiteral(red: 0.02352941176, green: 0.02352941176, blue: 0.02352941176, alpha: 0.4)
        
        self.layer.cornerRadius = 8
        self.layer.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.8980392157, blue: 1, alpha: 1)
        
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.02352941176, green: 0.02352941176, blue: 0.02352941176, alpha: 0.4)])
        self.font = UIFont(name: "Comfortaa Bold", size: 17)
        
    }
}
