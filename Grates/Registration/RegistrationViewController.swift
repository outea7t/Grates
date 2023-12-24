//
//  RegistrationViewController.swift
//  Grates
//
//  Created by Out East on 08.12.2023.
//

import Foundation
import UIKit

/// типы всех полей ввода текста
/// для того, чтобы мы могли определить степень сдвига, применяемого к frameView
fileprivate enum TypeOfTextField {
    case firstName
    case secondName
    case email
    case password
}

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpBigButton: UIButton!
    
    // для описания появившихся ошибок
    private let errorDescriptionView = ErrorDescriptionView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark), errorDescription: "Your error message here.")
    // для анимации view с описанием ошибки
    private var errorTopConstraint: NSLayoutConstraint?
    
    let firstNameTextField = RegisterTextField(placeholder: "first name")
    let secondNameTextField = RegisterTextField(placeholder: "second name")
    let emailTextField = RegisterTextField(placeholder: "example@gmail.com")
    let passwordTextField = RegisterTextField(placeholder: "password")
    
    private var isKeyboardShown = false
    private var textFieldType = TypeOfTextField.firstName
    
    private var user = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setSignInButton()
        self.setSignUpButton()
        self.setFrameView()
        self.setSignUpBigButton()
        self.setErrorDescriptionView()
        
        self.frameView.addSubview(self.secondNameTextField)
        self.frameView.addSubview(self.emailTextField)
        self.frameView.addSubview(self.passwordTextField)
        
        self.frameView.clipsToBounds = true
        
        self.firstNameTextField.delegate = self
        self.secondNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.transitioningDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setFirstNameTextField()
        self.setSecondNameTextField()
        self.setEmailTextField()
        self.setPasswordTextField()
        
        // отмена набора текста, когда пользователь нажимает на экран вне клавиатуры
        let keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(keyboardDismissGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // вызывается, когда клавиатура появится на экране
    // сделано для того, чтобы передвигать невидимые поля в зону видимости
    @objc private func keyboardWillShow() {
        guard self.isKeyboardShown == false else {
            return
        }
        self.isKeyboardShown = true
        
        let offset = 75
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.frameView.layer.position.y -= CGFloat(offset)
        }
    }
    
    // вызывается, когда клавиатура исчезает с экрана
    @objc private func keyboardWillHide() {
        let offset = 75
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.frameView.layer.position.y += CGFloat(offset)
        } completion: { isFinished in
            self.isKeyboardShown = false
        }
        
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func signUpBigButtonTapped(_ sender: UIButton) {
        self.handleRedisterRequest()
    }
    
    private func handleRedisterRequest() {
        DispatchQueue.global().async {
            do {
                try self.register()
            } catch {
                
            }
        }
    }
    
    // TODO: Сделать обработку всех ошибок
    private func register() throws {
        guard self.user.name != "" && self.user.surname != "" &&
                self.user.email != "" && self.user.password != "" else {
            
            return
        }
        let endPoint = NetworkCallInformation.Registration.authSignUp
        
        guard let url = URL(string: endPoint) else {
            throw UserDataError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        let jsonData = try encoder.encode(self.user)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error in request: \(error)")
                return
            }
            
            do {
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw UserDataError.invalidURL
                }
                
                if httpResponse.statusCode == 400 {
                    throw UserDataError.badRequest
                } else if httpResponse.statusCode == 409 {
                    throw UserDataError.conflict
                } else if httpResponse.statusCode == 500 {
                    throw UserDataError.internalServer
                }
                if httpResponse.statusCode == 200 {
                    print("SUCCESS")
                }
            }
            catch {
                guard let currentError = error as? UserDataError else {
                    
                    return
                }
            }
        }
        task.resume()
    }
    
}

extension RegistrationViewController {
    
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.firstNameTextField {
            self.textFieldType = .firstName
        }
        else if textField == self.secondNameTextField {
            self.textFieldType = .secondName
        }
        else if textField == self.emailTextField {
            self.textFieldType = .email
        }
        else if textField == self.passwordTextField {
            self.textFieldType = .password
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.firstNameTextField {
            self.secondNameTextField.becomeFirstResponder()
        }
        else if textField == self.secondNameTextField {
            self.emailTextField.becomeFirstResponder()
        }
        else if textField == self.emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    // TODO: Добавить валидацию
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case emailTextField:
            break
        case passwordTextField:
            break
            
        default:
            break
        }
        
        return true
    }
    
    // TODO: Сделать возможность показать кнопку "сделать пароль видимым"
    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard textField == self.passwordTextField else {
//            return
//        }
        
        if textField == self.firstNameTextField {
            self.user.name = textField.text ?? ""
            print(textField.text)
        }
        else if textField == self.secondNameTextField {
            self.user.surname = textField.text ?? ""
            print(textField.text)
        }
        else if textField == self.emailTextField {
            self.user.email = textField.text ?? ""
            print(textField.text)
        }
        else if textField == self.passwordTextField {
            self.user.password = textField.text ?? ""
            print(textField.text)
        }
        
    }
}

// настраиваем все view
extension RegistrationViewController {
    private func setSignUpButton() {
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        var signUpButtonConstraints = [NSLayoutConstraint]()
        
        signUpButtonConstraints.append(
            self.signUpButton.widthAnchor.constraint(equalToConstant: 140)
        )
        
        signUpButtonConstraints.append(
            self.signUpButton.heightAnchor.constraint(equalToConstant: 45)
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
            self.signInButton.widthAnchor.constraint(equalToConstant: 115)
        )
        signInButtonConstraints.append(
            self.signInButton.heightAnchor.constraint(equalToConstant: 45)
        )
        signInButtonConstraints.append(
            self.signInButton.trailingAnchor.constraint(equalTo: self.frameView.trailingAnchor, constant: -5)
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
        
        let widthConstraint = 330/390 * self.view.frame.width
        let heightConstraint = 500/844 * self.view.frame.height
        
        self.frameView.center = self.view.center
        self.frameView.frame.size = CGSize(width: widthConstraint, height: heightConstraint)
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
        self.frameView.addSubview(self.firstNameTextField)
        self.frameView.bringSubviewToFront(self.firstNameTextField)
        
        self.secondNameTextField.keyboardType = .default
        self.secondNameTextField.clearButtonMode = .never
        self.secondNameTextField.textContentType = .givenName
        self.secondNameTextField.autocapitalizationType = .words
        self.secondNameTextField.returnKeyType = .next
        
        self.firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.firstNameTextField.widthAnchor.constraint(equalToConstant: 275))
        constraints.append(self.firstNameTextField.heightAnchor.constraint(equalToConstant: 57))
        constraints.append(self.firstNameTextField.topAnchor.constraint(equalTo: self.signUpButton.bottomAnchor, constant: 40))
        constraints.append(self.firstNameTextField.centerXAnchor.constraint(equalTo: self.frameView.centerXAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    private func setSecondNameTextField() {
        self.frameView.addSubview(self.secondNameTextField)
        self.frameView.bringSubviewToFront(self.secondNameTextField)
        
        self.secondNameTextField.keyboardType = .default
        self.secondNameTextField.clearButtonMode = .never
        self.secondNameTextField.textContentType = .familyName
        self.secondNameTextField.autocapitalizationType = .words
        self.secondNameTextField.returnKeyType = .next
        
        self.secondNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.secondNameTextField.widthAnchor.constraint(equalToConstant: 275))
        constraints.append(self.secondNameTextField.heightAnchor.constraint(equalToConstant: 57))
        constraints.append(self.secondNameTextField.topAnchor.constraint(equalTo: self.firstNameTextField.bottomAnchor, constant: 11))
        constraints.append(self.secondNameTextField.centerXAnchor.constraint(equalTo: self.firstNameTextField.centerXAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    private func setEmailTextField() {
        self.frameView.addSubview(self.emailTextField)
        self.frameView.bringSubviewToFront(self.emailTextField)
        
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.clearButtonMode = .never
        self.emailTextField.textContentType = .emailAddress
        self.emailTextField.autocapitalizationType = .none
        self.emailTextField.returnKeyType = .next
        
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
        self.frameView.addSubview(self.passwordTextField)
        self.frameView.bringSubviewToFront(self.passwordTextField)
        
        self.passwordTextField.keyboardType = .default
        self.passwordTextField.clearButtonMode = .never
        self.passwordTextField.textContentType = .password
        self.passwordTextField.returnKeyType = .go
        self.passwordTextField.isSecureTextEntry = true
        
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            self.passwordTextField.widthAnchor.constraint(equalToConstant: 275),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 57),
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 11),
            self.passwordTextField.centerXAnchor.constraint(equalTo: self.frameView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setErrorDescriptionView() {
        self.errorDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = self.errorDescriptionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45)
        let constraints: [NSLayoutConstraint] = [
            self.errorDescriptionView.widthAnchor.constraint(equalToConstant: 370),
            self.errorDescriptionView.heightAnchor.constraint(equalToConstant: 90),
            self.errorDescriptionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            topConstraint
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// переход с меню входа на меню регистрации
extension RegistrationViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RegistrationViewsTransition(animationDuration: 1.5, animationType: .present)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RegistrationViewsTransition(animationDuration: 1.5, animationType: .dismiss)
    }
}
