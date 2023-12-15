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
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let _ = transitionContext.viewController(forKey: .from) else {
                  transitionContext.completeTransition(false)
                  return
              }
        print("Entered - 1")
        switch self.animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            self.presentTransition(with: transitionContext)
        case .dismiss:
            self.dismissTransition(with: transitionContext)
        }
    }
    
    private func dismissTransition(with transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    private func presentTransition(with transitionContext: UIViewControllerContextTransitioning) {
        print("Entered - 2")
        guard let registrationViewController = transitionContext.viewController(forKey: .to) as? RegistrationViewController,
        let logInViewController = transitionContext.viewController(forKey: .from) as? LogInViewController
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let toFrame = registrationViewController.frameView.frame
        let toSignInButtonFrame = registrationViewController.signInButton.frame
        let toSignUpButtonFrame = registrationViewController.signUpButton.frame
        let toSignUpBigButtonFrame = registrationViewController.signUpBigButton.frame
        let toEmailTextFieldFrame = registrationViewController.emailTextField.frame
        let toPasswordTextFieldFrame = registrationViewController.passwordTextField.frame
        
        registrationViewController.frameView.frame.size = logInViewController.frameView.frame.size
        registrationViewController.frameView.frame.origin = logInViewController.frameView.frame.origin
        registrationViewController.signUpBigButton.frame.size = logInViewController.logInButton.frame.size
        registrationViewController.signUpBigButton.frame.origin = logInViewController.logInButton.frame.origin
        registrationViewController.signUpBigButton.frame = registrationViewController.signUpBigButton.frame.offsetBy(dx: 0, dy: 150)
        
        guard let smallFontSize = registrationViewController.signInButton.titleLabel?.font.pointSize,
              let bigFontSize = registrationViewController.signUpButton.titleLabel?.font.pointSize else {
            transitionContext.completeTransition(false)
            return
        }
        
        registrationViewController.signUpButton.frame.size = logInViewController.signUpButton.frame.size
        registrationViewController.signUpButton.frame.origin = logInViewController.signUpButton.frame.origin
        if let titleLabel = registrationViewController.signUpButton.titleLabel {
            titleLabel.font = titleLabel.font.withSize(smallFontSize)
        }
        
        registrationViewController.signInButton.frame.size = logInViewController.signInButton.frame.size
        registrationViewController.signInButton.frame.origin = logInViewController.signInButton.frame.origin
        if let titleLabel = registrationViewController.signInButton.titleLabel {
            titleLabel.font = titleLabel.font.withSize(bigFontSize)
        }
        
        registrationViewController.firstNameTextField.layer.opacity = 0.0
        registrationViewController.secondNameTextField.layer.opacity = 0.0
        registrationViewController.emailTextField.layer.opacity = 0.0
        registrationViewController.passwordTextField.layer.opacity = 0.0
        registrationViewController.frameView.layer.opacity = 0.0
        
        // MARK: Анимируем LogInView
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseInOut) {
            logInViewController.emailTextField.layer.opacity = 0.0
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.15,
                       options: .curveEaseInOut) {
            logInViewController.passwordTextField.layer.opacity = 0.0
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.15,
                       options: .curveEaseInOut) {
            logInViewController.logInButton.layer.position.y += 100
        }
        UIView.animate(withDuration: 0.25,
                       delay: 0.15,
                       options: .curveEaseInOut) {
            logInViewController.forgotPasswordButton.layer.opacity = 0.0
        }
        
        UIView.animate(withDuration: 0.01, delay: 0.4) {
            registrationViewController.frameView.layer.opacity = 1.0
        }
        
        // MARK: Анимируем RegistrationView
        UIView.animate(withDuration: 1.0,
                       delay: 0.41,
                       options: .curveEaseOut) {
            registrationViewController.frameView.frame = toFrame
        }
        
        UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseOut) {
            if let titleLabel = registrationViewController.signInButton.titleLabel {
                registrationViewController.signInButton.titleLabel?.font = titleLabel.font.withSize(smallFontSize)
            }
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 1.5,
                       options: .curveEaseOut) {
            registrationViewController.firstNameTextField.layer.opacity = 1.0
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 1.65,
                       options: .curveEaseOut) {
            registrationViewController.secondNameTextField.layer.opacity = 1.0
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 1.8,
                       options: .curveEaseOut) {
            registrationViewController.emailTextField.layer.opacity = 1.0
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 1.95,
                       options: .curveEaseOut) {
            registrationViewController.passwordTextField.layer.opacity = 1.0
        }
        
        UIView.animate(withDuration: 0.3,
                       delay: 1.41,
                       options: .curveEaseOut) {
            registrationViewController.signUpBigButton.frame = toSignUpBigButtonFrame
        }
        
        UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseOut) {
            if let titleLabel = registrationViewController.signUpButton.titleLabel {
                registrationViewController.signUpButton.titleLabel?.font = titleLabel.font.withSize(bigFontSize)
            }
        } completion: { _ in
            let finished = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(finished)
        }
        
    }
}
