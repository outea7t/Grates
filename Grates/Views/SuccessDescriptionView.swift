//
//  SuccessDescriptionView.swift
//  Grates
//
//  Created by Out East on 25.12.2023.
//

import UIKit

/// Показывает сообщение об удавшемся действии пользователя
@IBDesignable
class SuccessDescriptionView: UIVisualEffectView {
    /// Показывает сообщение о действии пользователся
    private let descriptionLabel = UILabel()

    @IBInspectable var successDescription: String = "Your description here" {
        willSet {
            self.descriptionLabel.text = newValue
        }
    }
    
    convenience init(effect: UIVisualEffect?, description: String) {
        self.init(effect: effect)
        self.successDescription = description
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
        self.contentView.backgroundColor = #colorLiteral(red: 0, green: 0.8706611395, blue: 0, alpha: 0.5)
        self.backgroundColor = .clear
        
        self.descriptionLabel.textColor = .white
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.font = UIFont(name: "Comfortaa Bold", size: 15)
        self.descriptionLabel.textAlignment = .center
        
        self.contentView.addSubview(self.descriptionLabel)
        
        self.setDescriptionLabelConstraints()
    }
    
    private func setDescriptionLabelConstraints() {
//        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        let constraints: [NSLayoutConstraint] = [
//            self.descriptionLabel.widthAnchor.constraint(equalToConstant: 336),
//            self.descriptionLabel.heightAnchor.constraint(equalToConstant: 75),
//            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            self.descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7)
//        ]
//        
//        NSLayoutConstraint.activate(constraints)
    }
    
}
