//
//  ErrorDescriptionView.swift
//  Grates
//
//  Created by Out East on 24.12.2023.
//

import UIKit

/// Показывает сообщение об ошибке пользователю
/// Вынесен в отдельный класс, так как будет использоваться во всем приложении
@IBDesignable
class ErrorDescriptionView: UIVisualEffectView {
    /// Показывает сообщение "Error"
    private let errorLabel = UILabel()
    /// Показывает описание ошибки
    private let errorDescriptionLabel = UILabel()
    
    /// Описание ошибки в виде строки
    @IBInspectable var errorDescription: String = "Your error Here" {
        willSet {
            self.errorDescriptionLabel.text = newValue
        }
    }
    
    convenience init(effect: UIVisualEffect?, errorDescription: String) {
        self.init(effect: effect)
        self.errorDescription = errorDescription
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    private func setupViews() {
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.contentView.layer.cornerRadius = 16
        self.contentView.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.09563680738, alpha: 0.5)
        self.backgroundColor = .clear
        
        self.errorLabel.textColor = .white
        self.errorLabel.numberOfLines = 1
        self.errorLabel.font = UIFont(name: "Comfortaa Bold", size: 18)
        self.errorLabel.text = "Error"
        
        self.errorDescriptionLabel.textColor = .white
        self.errorDescriptionLabel.numberOfLines = 0
        self.errorDescriptionLabel.font = UIFont(name: "Comfortaa Bold", size: 14)
        
        self.contentView.addSubview(self.errorLabel)
        self.contentView.addSubview(self.errorDescriptionLabel)
        
        self.setErrorLabelConstraints()
        self.setErrorDescriptionLabelConstraints()
    }
    
    private func setErrorLabelConstraints() {
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            self.errorLabel.widthAnchor.constraint(equalToConstant: 68),
            self.errorLabel.heightAnchor.constraint(equalToConstant: 25),
            self.errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17),
            self.errorLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setErrorDescriptionLabelConstraints() {
        self.errorDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            self.errorDescriptionLabel.widthAnchor.constraint(equalToConstant: 336),
            self.errorDescriptionLabel.heightAnchor.constraint(equalToConstant: 56),
            self.errorDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17),
            self.errorDescriptionLabel.topAnchor.constraint(equalTo: self.errorLabel.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
