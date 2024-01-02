//
//  HeaderBackgroundView.swift
//  Grates
//
//  Created by Out East on 01.01.2024.
//

import UIKit

class HeaderBackgroundView: UIView {
    let blurView = UIVisualEffectView()
    
    convenience init(frame: CGRect, blurEffect: UIVisualEffect) {
        self.init(frame: frame)
        self.blurView.effect = blurEffect
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }
    
    private func setupViews() {
        // MARK: Настраиваем розовый эллипс
        let pinkShapeImage = UIImage(named: "PinkHeaderShape")
        let pinkShapeImageView = UIImageView(image: pinkShapeImage)
        pinkShapeImageView.contentMode = .scaleAspectFill
        pinkShapeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let pinkShapeImageSize = CGSize(width: 272, height: 64)
        self.addSubview(pinkShapeImageView)
        
        let pinkShapeConstraints: [NSLayoutConstraint] = [
            pinkShapeImageView.widthAnchor.constraint(equalToConstant: pinkShapeImageSize.width),
            pinkShapeImageView.heightAnchor.constraint(equalToConstant: pinkShapeImageSize.height),
            pinkShapeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            pinkShapeImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: -7)
        ]
        NSLayoutConstraint.activate(pinkShapeConstraints)
        
        // MARK: Настраиваем синий эллипс
        let blueShapeImage = UIImage(named: "BlueHeaderShape")
        let blueShapeImageView = UIImageView(image: blueShapeImage)
        blueShapeImageView.contentMode = .scaleAspectFill
        
        blueShapeImageView.translatesAutoresizingMaskIntoConstraints = false
        let blueShapeImageSize = CGSize(width: 207, height: 54)
        self.addSubview(blueShapeImageView)
        
        let blueShapeConstraints: [NSLayoutConstraint] = [
            blueShapeImageView.widthAnchor.constraint(equalToConstant: blueShapeImageSize.width),
            blueShapeImageView.heightAnchor.constraint(equalToConstant: blueShapeImageSize.height),
            blueShapeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -27),
            blueShapeImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: -11)
        ]
        NSLayoutConstraint.activate(blueShapeConstraints)
        
        // MARK: Настраиваем blur view
        self.addSubview(self.blurView)
        let effect = UIBlurEffect(style: .regular)
        self.blurView.effect = effect
        self.blurView.contentView.backgroundColor = .clear
        self.blurView.backgroundColor = .clear
        self.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.9333333333, blue: 1, alpha: 1)
        
        self.blurView.translatesAutoresizingMaskIntoConstraints = false
        let blurViewConstraints: [NSLayoutConstraint] = [
            self.blurView.topAnchor.constraint(equalTo: self.topAnchor),
            self.blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(blurViewConstraints)
        
    }
}
