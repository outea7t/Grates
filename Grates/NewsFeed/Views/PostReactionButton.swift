//
//  PostReactionButton.swift
//  Grates
//
//  Created by Out East on 01.01.2024.
//

import UIKit

@IBDesignable
class PostReactionButton: UIButton {
    private let label = UILabel()
    private let iconImageView = UIImageView()
    
    @IBInspectable var count: Int {
        willSet {
            self.label.text = "\(newValue)"
        }
    }
    @IBInspectable var imageName: String {
        willSet {
            let image = UIImage(named: "\(newValue)")
            self.iconImageView.image = image
        }
    }
    
    convenience init(frame: CGRect, count: Int, imageName: String) {
        let centeredOrigin = CGPoint(x: frame.origin.x - frame.size.width/2.0,
                                     y: frame.origin.y - frame.size.height/2.0)
        let centeredFrame = CGRect(origin: centeredOrigin, size: frame.size)
        self.init(frame: centeredFrame)
        self.count = count
        self.imageName = imageName
        self.setupViews(count: count, imageName: imageName)
    }
    
    override init(frame: CGRect) {
        self.count = 0
        self.imageName = ""
        super.init(frame: frame)
        self.setupViews(count: nil, imageName: nil)
    }
    required init?(coder: NSCoder) {
        self.count = 0
        self.imageName = ""
        super.init(coder: coder)
        self.setupViews(count: nil, imageName: nil)
    }
    
    private func setupViews(count: Int?, imageName: String?) {
        guard let count = count, let imageName = imageName else {
            return
        }
        
        self.backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.2078431373, blue: 0.6980392157, alpha: 0.25)
        self.layer.cornerRadius = self.frame.height/2.0
        
        self.label.font = UIFont(name: "Comfortaa Bold", size: 13)
        self.label.textColor = #colorLiteral(red: 0.1764705882, green: 0.1529411765, blue: 0.3254901961, alpha: 1)
        self.label.text = "\(count)"
        self.label.textAlignment = .left
        self.label.frame.size = CGSize(width: 35, height: 20)
        
        self.iconImageView.contentMode = .scaleAspectFit
        
        let image = UIImage(systemName: imageName)
        if let image = image {
            self.iconImageView.image = image
        }
        self.iconImageView.tintColor = #colorLiteral(red: 0.1764705882, green: 0.1529411765, blue: 0.3254901961, alpha: 1)
        
        self.addSubview(self.iconImageView)
        self.addSubview(self.label)
        
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        let iconImageConstraints: [NSLayoutConstraint] = [
            self.iconImageView.widthAnchor.constraint(equalToConstant: 18),
            self.iconImageView.heightAnchor.constraint(equalToConstant: 18),
            self.iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -1),
            self.iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(iconImageConstraints)
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        let labelConstraints: [NSLayoutConstraint] = [
            self.label.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.label.widthAnchor.constraint(equalToConstant: 35),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(labelConstraints)
    }
}
