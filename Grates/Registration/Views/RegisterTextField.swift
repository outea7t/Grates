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
    
    func wrongInput() {
        self.textColor = #colorLiteral(red: 1, green: 0.09411764706, blue: 0.09411764706, alpha: 0.4)
    }
    
    func normalInput() {
        self.textColor = #colorLiteral(red: 0.02352941176, green: 0.02352941176, blue: 0.02352941176, alpha: 0.4)
    }
    
    private func setupTextField(placeholder: String) {
        self.textColor = #colorLiteral(red: 0.02352941176, green: 0.02352941176, blue: 0.02352941176, alpha: 0.4)
        
        self.layer.cornerRadius = 8
        self.layer.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.8980392157, blue: 1, alpha: 1)
        
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.02352941176, green: 0.02352941176, blue: 0.02352941176, alpha: 0.4)])
        self.font = UIFont(name: "Comfortaa Bold", size: 17)
        
        // устанавливаем кнопку для очищения всего ввода
        let buttonImage = UIImage(systemName: "xmark.circle")?.withTintColor(#colorLiteral(red: 0.3503245711, green: 0.4441066086, blue: 0.664519608, alpha: 1), renderingMode: .alwaysOriginal)
        
        
        let clearButton = UIImageView(image: buttonImage)
        clearButton.contentMode = .scaleAspectFit
        clearButton.isUserInteractionEnabled = true
        clearButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clearTextField))
        clearButton.addGestureRecognizer(tapGesture)
        
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width-35, y: bounds.height/4, width: 25, height: 25)
    }
    
    @objc private func clearTextField() {
        self.text = ""
    }
    
}
