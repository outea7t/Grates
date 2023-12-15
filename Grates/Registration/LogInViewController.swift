//
//  ViewController.swift
//  Grates
//
//  Created by Out East on 07.12.2023.
//

import UIKit
import RiveRuntime

class LogInViewController: UIViewController {

    // задний фон из райва
    let backgroundView = RiveView()
    let backgroundViewModel = RiveViewModel(fileName: "shapesanimation")
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    let emailTextField = RegisterTextField(placeholder: "example@email.com")
    let passwordTextField = RegisterTextField(placeholder: "password")
    
    var blurView: UIVisualEffectView?
    let gradientView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setRiveView()
        self.setBlurView()
        self.setGradientLayer()
        self.setFrameView()
        
        self.setEmailTextField()
        self.setPasswordTextField()
        self.setLogInButton()
        self.setSignInButton()
        self.setSignUpButton()
        self.setForgotPasswordButton()
        self.view.bringSubviewToFront(self.logoLabel)
        
        self.frameView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: SeguesNames.loginToRegistration.rawValue, sender: self)
    }
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        
    }
    @IBAction func LogInButtonTapped(_ sender: UIButton) {
        
    }
    
    // настраиваем градиент на фоне
    private func setGradientLayer() {
        self.gradientView.frame = self.view.bounds
        self.gradientView.center = self.view.center
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.737254902, green: 0.4588235294, blue: 0.9568627451, alpha: 1).cgColor, #colorLiteral(red: 0.1529411765, green: 0, blue: 0.3647058824, alpha: 1).cgColor, #colorLiteral(red: 0.1607843137, green: 0.137254902, blue: 0.2941176471, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        self.gradientView.layer.addSublayer(gradientLayer)
        
        self.view.addSubview(self.gradientView)
        self.view.sendSubviewToBack(self.gradientView)
    }
    // настройка фоновой анимации
    private func setRiveView() {
        // настраиваем riveView
        self.backgroundViewModel.setView(self.backgroundView)
        self.backgroundViewModel.play(animationName: "Ambient", loop: .loop)
        
        self.backgroundViewModel.alignment = .center
        self.backgroundViewModel.fit = .fill
        
        self.view.addSubview(self.backgroundView)
        self.view.sendSubviewToBack(self.backgroundView)
        
        self.backgroundView.frame = self.view.bounds
        self.backgroundView.center = self.view.center
    }
    // настройка blur view
    private func setBlurView() {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        
        blurView.frame = self.view.bounds
        blurView.center = self.view.center
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.737254902, green: 0.4588235294, blue: 0.9568627451, alpha: 1).withAlphaComponent(0.2).cgColor, #colorLiteral(red: 0.1529411765, green: 0, blue: 0.3647058824, alpha: 1).withAlphaComponent(0.2).cgColor, #colorLiteral(red: 0.1607843137, green: 0.137254902, blue: 0.2941176471, alpha: 1).withAlphaComponent(0.2).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        blurView.layer.addSublayer(gradientLayer)
        
        self.view.addSubview(blurView)
        self.view.bringSubviewToFront(blurView)
        self.blurView = blurView
    }
    // настраиваем задний фон для окна регистрации
    private func setFrameView() {
        self.view.bringSubviewToFront(self.frameView)
        self.frameView.layer.cornerRadius = 16
        self.frameView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.frameView.layer.shadowRadius = 8
        self.frameView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        let origin = CGPoint(x: self.frameView.frame.origin.x, y: self.frameView.frame.origin.y - 4)
        let shadowRect = CGRect(origin: origin,
                                size: CGSize(width: self.frameView.frame.width + 8, height: self.frameView.frame.height + 8))
        
        let widthConstraint = 330/390 * self.view.frame.width
        let heightConstraint = 420/844 * self.view.frame.height
        
        self.frameView.center = self.view.center
        self.frameView.frame.size = CGSize(width: widthConstraint, height: heightConstraint)
    
//        self.frameView.translatesAutoresizingMaskIntoConstraints = false
//        
//        var frameViewConstraints = [NSLayoutConstraint]()
//        
//        frameViewConstraints.append(
//            self.frameView.widthAnchor.constraint(equalToConstant: 330)
//        )
//        frameViewConstraints.append(
//            self.frameView.heightAnchor.constraint(equalToConstant: 420)
//        )
//        frameViewConstraints.append(
//            self.frameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
//        )
//        frameViewConstraints.append(
//            self.frameView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
//        )
//        
//        NSLayoutConstraint.activate(frameViewConstraints)
    }
    
    private func setEmailTextField() {
        self.frameView.addSubview(self.emailTextField)
        self.frameView.bringSubviewToFront(self.emailTextField)
        
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        var emailTextFieldConstraints = [NSLayoutConstraint]()
        emailTextFieldConstraints.append(
            self.emailTextField.topAnchor.constraint(equalTo: self.frameView.topAnchor, constant: 130)
        )
        emailTextFieldConstraints.append(
            self.emailTextField.widthAnchor.constraint(equalToConstant: 275)
        )
        emailTextFieldConstraints.append(
            self.emailTextField.heightAnchor.constraint(equalToConstant: 55)
        )
        emailTextFieldConstraints.append(
            self.emailTextField.centerXAnchor.constraint(equalTo: self.frameView.centerXAnchor)
        )
        
        NSLayoutConstraint.activate(emailTextFieldConstraints)
    }
    
    private func setPasswordTextField() {
        self.frameView.addSubview(self.passwordTextField)
        self.frameView.bringSubviewToFront(self.passwordTextField)
        
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        var passwordTextFieldConstraints = [NSLayoutConstraint]()
        passwordTextFieldConstraints.append(
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 12)
        )
        passwordTextFieldConstraints.append(
            self.passwordTextField.widthAnchor.constraint(equalToConstant: 275)
        )
        passwordTextFieldConstraints.append(
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 55)
        )
        passwordTextFieldConstraints.append(
            self.passwordTextField.centerXAnchor.constraint(equalTo: self.frameView.centerXAnchor)
        )
        
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
    }
    
    private func setLogInButton() {
        self.logInButton.tintColor = #colorLiteral(red: 0.1529411765, green: 0, blue: 0.3647058824, alpha: 1)
        self.logInButton.layer.cornerRadius = 13
        
        self.logInButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.logInButton.layer.shadowRadius = 6
        self.logInButton.layer.shadowOpacity = 1.0
        
        let shadowRect = CGRect(x: self.logInButton.frame.origin.x,
                                y: self.logInButton.frame.origin.y,
                                width: self.logInButton.frame.width + 50,
                                height: self.logInButton.frame.height)
        
        let shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 13).cgPath
        
        self.logInButton.layer.shadowPath = shadowPath
        self.logInButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private func setSignUpButton() {
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.titleLabel?.numberOfLines = 1
        self.signUpButton.titleLabel?.lineBreakMode = .byWordWrapping
        self.signUpButton.titleLabel?.textAlignment = .left
        
        var signUpButtonConstraints = [NSLayoutConstraint]()
        
        signUpButtonConstraints.append(
            self.signUpButton.widthAnchor.constraint(equalToConstant: 130)
        )
        
        signUpButtonConstraints.append(
            self.signUpButton.heightAnchor.constraint(equalToConstant: 25)
        )
        
        signUpButtonConstraints.append(
            self.signUpButton.leadingAnchor.constraint(equalTo: self.frameView.leadingAnchor, constant: -5)
        )
        
        signUpButtonConstraints.append(
            self.signUpButton.topAnchor.constraint(equalTo: self.frameView.topAnchor, constant: 33)
        )
        
        NSLayoutConstraint.activate(signUpButtonConstraints)
        
        self.signUpButton.transform = CGAffineTransformScale(self.signUpButton.transform, 0.5, 0.5)
    }
    
    private func setSignInButton() {
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        var signInButtonConstraints = [NSLayoutConstraint]()
        
        signInButtonConstraints.append(
            self.signInButton.widthAnchor.constraint(equalToConstant: 114)
        )
        
        signInButtonConstraints.append(
            self.signInButton.heightAnchor.constraint(equalToConstant: 46)
        )
        
        signInButtonConstraints.append(
            self.signInButton.trailingAnchor.constraint(equalTo: self.frameView.trailingAnchor, constant: -15)
        )
        
        signInButtonConstraints.append(
            self.signInButton.topAnchor.constraint(equalTo: self.frameView.topAnchor, constant: 22)
        )
        
        NSLayoutConstraint.activate(signInButtonConstraints)
    }
    
    private func setForgotPasswordButton() {
        self.forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        var forgotPasswordConstraints = [NSLayoutConstraint]()
        
        forgotPasswordConstraints.append(
            self.forgotPasswordButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 6)
        )
        forgotPasswordConstraints.append(
            self.forgotPasswordButton.centerXAnchor.constraint(equalTo: self.frameView.centerXAnchor)
        )
        forgotPasswordConstraints.append(
            self.forgotPasswordButton.widthAnchor.constraint(equalToConstant: 150)
        )
        forgotPasswordConstraints.append(
            self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 25)
        )
        
        NSLayoutConstraint.activate(forgotPasswordConstraints)
    }
}

