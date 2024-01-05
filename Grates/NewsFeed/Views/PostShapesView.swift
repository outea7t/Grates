//
//  OvalView.swift
//  Grates
//
//  Created by Out East on 02.01.2024.
//

import UIKit

class PostShapesView: UIView {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        let colors: [UIColor] = [
            #colorLiteral(red: 0.6156862745, green: 0.1254901961, blue: 1, alpha: 1),
            #colorLiteral(red: 0.2666666667, green: 0.2509803922, blue: 1, alpha: 1),
            #colorLiteral(red: 0.08235294118, green: 0, blue: 1, alpha: 1),
            #colorLiteral(red: 1, green: 0.2509803922, blue: 0.8784313725, alpha: 1)
        ].shuffled()
        let sizes: [CGSize] = [
            CGSize(width: 162, height: 51),
            CGSize(width: 192, height: 71),
            CGSize(width: 245, height: 85),
            CGSize(width: 172, height: 93)
        ].shuffled()
        let positions: [CGPoint] = [
            CGPoint(x: -53, y: 20),
            CGPoint(x: 247, y: 0),
            CGPoint(x: 11, y: 30),
            CGPoint(x: 124, y: 10)
        ].shuffled()
        
        let randomIndexes = [0,1,2,3].shuffled()
        print(randomIndexes)
        for i in 0..<randomIndexes.count {
            let flattenedRect = CGRect(origin: positions[i],
                                       size: sizes[i])
            let flattenedOvalPath = UIBezierPath(ovalIn: flattenedRect)
            colors[i].setFill()
            flattenedOvalPath.usesEvenOddFillRule = true
            flattenedOvalPath.fill()
        }
    }
}
