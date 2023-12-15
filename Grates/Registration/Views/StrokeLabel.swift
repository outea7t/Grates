////
////  StrokeLabel.swift
////  Grates
////
////  Created by Out East on 15.12.2023.
////
//
//import UIKit
//
//class StrokeLabel: UILabel {
//    
//    var strokeWidth: CGFloat = 1.0
//    
//    override func draw(_ rect: CGRect) {
//        let font = UIFont(name: "Comfortaa", size: 30)
//        
//        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
//            NSAttributedString.Key.strokeColor: #colorLiteral(red: 0.1670107543, green: 0, blue: 0.3726699948, alpha: 1),
//            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1670107543, green: 0, blue: 0.3726699948, alpha: 1),
//            NSAttributedString.Key.strokeWidth: -self.strokeWidth,
//            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 30)
//        ]
//        
//        let attributedString = NSAttributedString(string: "Sign In", attributes: strokeTextAttributes)
//        
//        attributedString.draw(in: rect)
//    }
//    
//    
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//
//}
