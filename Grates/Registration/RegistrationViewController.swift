//
//  RegistrationViewController.swift
//  Grates
//
//  Created by Out East on 08.12.2023.
//

import Foundation
import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpBigButton: UIButton!
    
    let firstNameTextField = RegisterTextField(placeholder: "first name")
    let secondNameTextField = RegisterTextField(placeholder: "second name")
    let emailTextField = RegisterTextField(placeholder: "example@gmail.com")
    let passwordTextField = RegisterTextField(placeholder: "password")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setSignInButton()
        self.setSignUpButton()
        self.setFrameView()
        self.setSignUpBigButton()
        
        self.frameView.addSubview(self.firstNameTextField)
        self.frameView.addSubview(self.secondNameTextField)
        self.frameView.addSubview(self.emailTextField)
        self.frameView.addSubview(self.passwordTextField)
        
        self.frameView.clipsToBounds = true
        self.transitioningDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setFrameViewConstraints()
        self.setFirstNameTextField()
        self.setSecondNameTextField()
        self.setEmailTextField()
        self.setPasswordTextField()
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func signUpBigButtonTapped(_ sender: UIButton) {
    }
    
    private func setSignUpButton() {
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        var signUpButtonConstraints = [NSLayoutConstraint]()
        
        signUpButtonConstraints.append(
            self.signUpButton.widthAnchor.constraint(equalToConstant: 146)
        )
        
        signUpButtonConstraints.append(
            self.signUpButton.heightAnchor.constraint(equalToConstant: 46)
        )
        
        signUpButtonConstraints.append(
            self.signUpButton.leadingAnchor.constraint(equalTo: self.frameView.leadingAnchor, constant: 8)
        )
        
        signUpButtonConstraints.append(
            self.signUpButton.topAnchor.constraint(equalTo: self.frameView.topAnchor, constant: 18)
        )
        
        NSLayoutConstraint.activate(signUpButtonConstraints)
    }
    private func setSignInButton() {
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        var signInButtonConstraints = [NSLayoutConstraint]()
        
        signInButtonConstraints.append(
            self.signInButton.widthAnchor.constraint(equalToConstant: 130)
        )
        signInButtonConstraints.append(
            self.signInButton.heightAnchor.constraint(equalToConstant: 46)
        )
        signInButtonConstraints.append(
            self.signInButton.trailingAnchor.constraint(equalTo: self.frameView.trailingAnchor, constant: 0)
        )
        signInButtonConstraints.append(
            self.signInButton.topAnchor.constraint(equalTo: self.frameView.topAnchor, constant: 18)
        )
        NSLayoutConstraint.activate(signInButtonConstraints)
        
        self.signInButton.transform = CGAffineTransformScale(self.signInButton.transform, 0.5, 0.5)
    }
    
    private func setFrameView() {
        self.view.bringSubviewToFront(self.frameView)
        
        self.frameView.layer.cornerRadius = 16
        self.frameView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.frameView.layer.shadowRadius = 8
        self.frameView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        let origin = CGPoint(x: self.frameView.frame.origin.x, y: self.frameView.frame.origin.y - 4)
        let shadowRect = CGRect(origin: origin,
                                size: CGSize(width: self.frameView.frame.width + 8, height: self.frameView.frame.height + 8))
    }
    
    private func setFrameViewConstraints() {
//        self.frameView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let frameViewConstraints: [NSLayoutConstraint] = [
//            self.frameView.widthAnchor.constraint(equalToConstant: 330),
//            self.frameView.heightAnchor.constraint(equalToConstant: 420*1.2),
//            self.frameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            self.frameView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
//        ]
        
//        NSLayoutConstraint.activate(frameViewConstraints)
    }
    private func setSignUpBigButton() {
        self.signUpBigButton.tintColor = #colorLiteral(red: 0.1529411765, green: 0, blue: 0.3647058824, alpha: 1)
        self.signUpBigButton.layer.cornerRadius = 13
        
        self.signUpBigButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.signUpBigButton.layer.shadowRadius = 6
        self.signUpBigButton.layer.shadowOpacity = 1.0
        
        let shadowRect = CGRect(x: self.signUpBigButton.frame.origin.x,
                                y: self.signUpBigButton.frame.origin.y,
                                width: self.signUpBigButton.frame.width + 50,
                                height: self.signUpBigButton.frame.height)
        
        let shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 13).cgPath
        
        self.signUpBigButton.layer.shadowPath = shadowPath
        self.signUpBigButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        self.signUpBigButton.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            self.signUpBigButton.widthAnchor.constraint(equalToConstant: 275),
            self.signUpBigButton.heightAnchor.constraint(equalToConstant: 57),
            self.signUpBigButton.centerXAnchor.constraint(equalTo: self.frameView.centerXAnchor),
            self.signUpBigButton.bottomAnchor.constraint(equalTo: self.frameView.bottomAnchor, constant: -13)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setFirstNameTextField() {
        
        self.firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.firstNameTextField.widthAnchor.constraint(equalToConstant: 275))
        constraints.append(self.firstNameTextField.heightAnchor.constraint(equalToConstant: 57))
        constraints.append(self.firstNameTextField.topAnchor.constraint(equalTo: self.signUpButton.bottomAnchor, constant: 40))
        constraints.append(self.firstNameTextField.centerXAnchor.constraint(equalTo: self.frameView.centerXAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    private func setSecondNameTextField() {
        
        self.secondNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.secondNameTextField.widthAnchor.constraint(equalToConstant: 275))
        constraints.append(self.secondNameTextField.heightAnchor.constraint(equalToConstant: 57))
        constraints.append(self.secondNameTextField.topAnchor.constraint(equalTo: self.firstNameTextField.bottomAnchor, constant: 11))
        constraints.append(self.secondNameTextField.centerXAnchor.constraint(equalTo: self.firstNameTextField.centerXAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    private func setEmailTextField() {
        
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            self.emailTextField.widthAnchor.constraint(equalToConstant: 275),
            self.emailTextField.heightAnchor.constraint(equalToConstant: 57),
            self.emailTextField.topAnchor.constraint(equalTo: self.secondNameTextField.bottomAnchor, constant: 11),
            self.emailTextField.centerXAnchor.constraint(equalTo: self.frameView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    private func setPasswordTextField() {
        
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            self.passwordTextField.widthAnchor.constraint(equalToConstant: 275),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 57),
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 11),
            self.passwordTextField.centerXAnchor.constraint(equalTo: self.frameView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension RegistrationViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RegistrationViewsTransition(animationDuration: 1.5, animationType: .present)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RegistrationViewsTransition(animationDuration: 1.5, animationType: .dismiss)
    }
}
