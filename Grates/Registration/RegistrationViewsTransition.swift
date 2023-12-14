//
//  RegistrationViewsTransition.swift
//  Grates
//
//  Created by Out East on 08.12.2023.
//

import Foundation
import UIKit

class RegistrationViewsTransition: NSObject {
    enum AnimationType {
        case present
        case dismiss
    }
    private let animationDuration: TimeInterval
    private let animationType: AnimationType
    
    init(animationDuration: TimeInterval, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

extension RegistrationViewsTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        <#code#>
    }
    
    private func dismissTransition(with transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    private func presentTransition(with transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
