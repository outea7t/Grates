//
//  OvalView.swift
//  Grates
//
//  Created by Out East on 02.01.2024.
//

import UIKit

class OvalView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let colors: [UIColor] = [
            #colorLiteral(red: 0.6156862745, green: 0.1254901961, blue: 1, alpha: 1),
            #colorLiteral(red: 0.2666666667, green: 0.2509803922, blue: 1, alpha: 1),
            #colorLiteral(red: 0.08235294118, green: 0, blue: 1, alpha: 1),
            #colorLiteral(red: 1, green: 0.2509803922, blue: 0.8784313725, alpha: 1)
        ]
        let height = CGFloat.random(in: 71...93)
        let width = CGFloat.random(in: 192...245)
        let randomColor = colors[Int.random(in: 0..<colors.count)]
        randomColor.setFill()
        
//        let path = UIBezierPath
    }
    

}
