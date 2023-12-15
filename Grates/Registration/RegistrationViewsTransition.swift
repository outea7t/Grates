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
        print("Entered - 3")
        guard let registrationViewController = transitionContext.viewController(forKey: .from) as? RegistrationViewController,
              let logInViewController = transitionContext.viewController(forKey: .to) as? LogInViewController else {
            transitionContext.completeTransition(false)
            return
        }
        
        let toFrame = logInViewController.frameView.frame
        let toLogInButtonFrame = logInViewController.logInButton.frame.offsetBy(dx: 0, dy: -100)
        let toSignInButtonOrigin = logInViewController.signInButton.frame.origin
        let toSignUpButtonOrigin = logInViewController.signUpButton.frame.origin
        
        logInViewController.frameView.frame.size = registrationViewController.frameView.frame.size
        logInViewController.frameView.frame.origin = registrationViewController.frameView.frame.origin
        logInViewController.logInButton.frame = logInViewController.logInButton.frame.offsetBy(dx: 0, dy: 100)
        
        logInViewController.emailTextField.alpha = 0
        logInViewController.passwordTextField.alpha = 0
        logInViewController.forgotPasswordButton.alpha = 0
        
        logInViewController.signUpButton.transform = CGAffineTransformScale(logInViewController.signUpButton.transform, 0.5, 0.5)
        logInViewController.signInButton.transform = CGAffineTransform.identity
        
        // MARK: Анимируем RegistrationViewController
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            registrationViewController.signUpButton.transform = CGAffineTransformScale(registrationViewController.signUpButton.transform, 0.5, 0.5)
//            registrationViewController.signUpButton.frame.origin = toSignUpButtonOrigin
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            registrationViewController.signInButton.transform = CGAffineTransform.identity
//            registrationViewController.signInButton.frame.origin = toSignInButtonOrigin
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.15, options: .curveEaseOut) {
            registrationViewController.firstNameTextField.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.3, options: .curveEaseOut) {
            registrationViewController.secondNameTextField.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.45, options: .curveEaseOut) {
            registrationViewController.emailTextField.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.6, options: .curveEaseOut) {
            registrationViewController.passwordTextField.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.3, options: .curveEaseOut) {
            registrationViewController.signUpBigButton.frame = registrationViewController.signUpBigButton.frame.offsetBy(dx: 0, dy: 150)
        }
        
        UIView.animate(withDuration: 0.01, delay: 0.5, options: .curveEaseOut) {
            registrationViewController.frameView.alpha = 0.0
        }
        
        // MARK: Анимируем LogInViewController
        
        UIView.animate(withDuration: 1.0, delay: 0.51, options: .curveEaseOut) {
            logInViewController.frameView.frame = toFrame
        }
        
        UIView.animate(withDuration: 0.25, delay: 1.51, options: .curveEaseOut) {
            logInViewController.emailTextField.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.25, delay: 1.66, options: .curveEaseOut) {
            logInViewController.passwordTextField.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.3, delay: 1.55, options: .curveEaseOut) {
            logInViewController.logInButton.frame = toLogInButtonFrame
        }
        
        UIView.animate(withDuration: 0.3, delay: 1.81, options: .curveEaseOut) {
            logInViewController.forgotPasswordButton.alpha = 1.0
        } completion: { isEnded in
            transitionContext.completeTransition(isEnded)
        }
//        let toFrame =
    }
    
    private func presentTransition(with transitionContext: UIViewControllerContextTransitioning) {
        print("Entered - 2")
        guard let registrationViewController = transitionContext.viewController(forKey: .to) as? RegistrationViewController,
              let logInViewController = transitionContext.viewController(forKey: .from) as? LogInViewController else {
            transitionContext.completeTransition(false)
            return
        }
        
        let toFrame = registrationViewController.frameView.frame
        let toSignUpBigButtonFrame = registrationViewController.signUpBigButton.frame
        
        registrationViewController.frameView.frame.size = logInViewController.frameView.frame.size
        registrationViewController.frameView.frame.origin = logInViewController.frameView.frame.origin
        
        registrationViewController.signUpBigButton.frame.size = logInViewController.logInButton.frame.size
        registrationViewController.signUpBigButton.frame.origin = logInViewController.logInButton.frame.origin
        registrationViewController.signUpBigButton.frame = registrationViewController.signUpBigButton.frame.offsetBy(dx: 0, dy: 150)
        
        registrationViewController.firstNameTextField.alpha = 0.0
        registrationViewController.secondNameTextField.alpha = 0.0
        registrationViewController.emailTextField.alpha = 0.0
        registrationViewController.passwordTextField.alpha = 0.0
        registrationViewController.frameView.alpha = 0.0
//        registrationViewController.frameView.transform = CGAffineTransformScale(registrationViewController.frameView.transform, 1.0, 1.0/1.2)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut) {
            logInViewController.signInButton.transform = CGAffineTransformScale(logInViewController.signInButton.transform, 0.5, 0.5)
        }
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut) {
            logInViewController.signUpButton.transform = CGAffineTransform.identity
            logInViewController.signUpButton.layer.position.x += 25
        }
        // MARK: Анимируем LogInView
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseInOut) {
            logInViewController.emailTextField.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.15,
                       options: .curveEaseInOut) {
            logInViewController.passwordTextField.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.15,
                       options: .curveEaseInOut) {
            logInViewController.logInButton.layer.position.y += 100
        }
        UIView.animate(withDuration: 0.25,
                       delay: 0.15,
                       options: .curveEaseInOut) {
            logInViewController.forgotPasswordButton.alpha = 0.0
        }
        
        // MARK: Анимируем RegistrationView
        UIView.animate(withDuration: 0.01, delay: 0.6) {
            registrationViewController.frameView.alpha = 1.0
        }
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.65,
                       options: .curveEaseOut) {
            registrationViewController.frameView.frame = toFrame
        }
        
        UIView.animate(withDuration: 0.3,
                       delay: 1.5,
                       options: .curveEaseInOut) {
            registrationViewController.firstNameTextField.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.3,
                       delay: 1.65,
                       options: .curveEaseInOut) {
            registrationViewController.secondNameTextField.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.3,
                       delay: 1.8,
                       options: .curveEaseInOut) {
            registrationViewController.emailTextField.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.3,
                       delay: 1.95,
                       options: .curveEaseInOut) {
            registrationViewController.passwordTextField.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.3,
                       delay: 1.41,
                       options: .curveEaseOut) {
            registrationViewController.signUpBigButton.frame = toSignUpBigButtonFrame
        } completion: { _ in
       let finished = !transitionContext.transitionWasCancelled
       transitionContext.completeTransition(finished)
   }
        
        
    }
}
