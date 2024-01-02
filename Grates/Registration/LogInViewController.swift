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
    
    // для описания появившихся ошибок
    private let errorDescriptionView = ErrorDescriptionView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark), errorDescription: "Your error message here.")
    private var isErrorDescriptionViewAnimated = false
    
    let emailTextField = RegisterTextField(placeholder: "example@email.com")
    let passwordTextField = RegisterTextField(placeholder: "password")
    private var hasEmailPassedValidation = false
    private var hasPasswordPassedValidation = true
    
    private var blurView: UIVisualEffectView?
    let gradientView = UIView()
    private var isKeyboardShown = false
    
    var userLoginData = UserLoginData()
    /// access и refresh токены, которые генерируется после входа
    var tokens: Tokens?
    // содержит id пользователя (для переотправления письма пользователю)
    var registredUserData: RegistredUserData?
    var userEmail: UserEmail?
    
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
        self.setErrorDescriptionView()
        
        self.frameView.clipsToBounds = true
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        
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
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.frameView.layer.position.y -= 50
        }
    }
    
    // вызывается, когда клавиатура исчезает с экрана
    @objc private func keyboardWillHide() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.frameView.layer.position.y += 50
        } completion: { isFinished in
            self.isKeyboardShown = false
        }
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: SeguesNames.loginToRegistration.rawValue, sender: self)
    }
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        
    }
    @IBAction func LogInButtonTapped(_ sender: UIButton) {
        self.handleLoginRequest()
    }
    
    func handleLoginRequest() {
        DispatchQueue.main.async {
            do {
                try self.login()
            } catch {
                self.badRequest()
            }
        }
    }
    
    func login() throws {
        guard self.userLoginData.email != "" && self.userLoginData.password != "" else {
            self.allFieldsArentFilled()
            return
        }
        
        guard self.validateEmail() else {
            self.incorrectEmail()
            return
        }
        
        guard self.validatePassword() else {
            self.incorrectPassword()
            return
        }
        
        let endPoint = NetworkCallInformation.Registration.authSignIn
        
        guard let url = URL(string: endPoint) else {
            throw RegistrationError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        let jsonData = try? encoder.encode(self.userLoginData)
        if let jsonData = jsonData {
            request.httpBody = jsonData
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                
                if let error = error {
                    print("Error in request: \(error)")
                    throw RegistrationError.badRequest
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RegistrationError.invalidURL
                }
                
                if httpResponse.statusCode == 400 {
                    throw RegistrationError.badRequest
                } else if httpResponse.statusCode == 401 {
                    throw RegistrationError.unauthorized
                }
                if httpResponse.statusCode == 200, let data = data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    self.tokens = try? decoder.decode(Tokens.self, from: data)
                    
                    DispatchQueue.main.sync {
                        self.performSegue(withIdentifier: SeguesNames.loginToEmailConfirmation.rawValue, sender: self)
                    }
                }
            } catch {
                guard let currentError = error as? RegistrationError else {
                    print("Uncaught error")
                    return
                }
                switch currentError {
                case .badRequest:
                    self.badRequest()
                case .unauthorized:
                    self.unauthorized()
                case .invalidURL:
                    self.badRequest()
                case .userNotFound:
                    break
                case .conflict:
                    break
                case .internalServer:
                    break
                }
            }
        }
        
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let emailConfirmationVC = segue.destination as? EmailConfiramtionViewController {
            print("sent to confirm")
            emailConfirmationVC.registredUserData = self.registredUserData
            emailConfirmationVC.userEmail = self.userEmail
        }
    }
    
    @IBAction func unwindToLogIn(_ sender: UIStoryboardSegue) {
        
    }
}
// обрабатываем ошибки с запросов
extension LogInViewController {
    private func allFieldsArentFilled() {
        DispatchQueue.main.async {
            self.errorDescriptionView.errorDescription = "All fields should be filled."
            self.animateErrorView()
            
            if self.emailTextField.text == "" {
                self.emailTextField.wrongInput()
            }
            if self.passwordTextField.text == "" {
                self.passwordTextField.wrongInput()
            }
        }
    }
    
    private func incorrectEmail() {
        DispatchQueue.main.async {
            self.errorDescriptionView.errorDescription = "Incorrect e-mail."
            self.animateErrorView()
            
            self.emailTextField.wrongInput()
        }
    }
    
    private func incorrectPassword() {
        DispatchQueue.main.async {
            self.errorDescriptionView.errorDescription = "Password length should be at least 8 charachters."
            self.animateErrorView()
            self.passwordTextField.wrongInput()
        }
    }
    
    private func badRequest() {
        DispatchQueue.main.async {
            self.errorDescriptionView.errorDescription = "Something went wrong, try again later."
            self.animateErrorView()
        }
    }
    
    private func unauthorized() {
        DispatchQueue.main.async {
            self.errorDescriptionView.errorDescription = "User with this e-mail doesn't exist, try to sign up instead"
            self.animateErrorView()
        }
    }
    
    private func internalServerError() {
        DispatchQueue.main.async {
            self.errorDescriptionView.errorDescription = "Something went wrong, try again later."
            self.animateErrorView()
        }
    }
    
    private func animateErrorView() {
        
        guard !self.isErrorDescriptionViewAnimated else {
            return
        }
        self.isErrorDescriptionViewAnimated = true
        
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       options: .curveEaseInOut) {
            self.errorDescriptionView.layer.position.y += 150
        }
        
        UIView.animate(withDuration: 0.35,
                       delay: 5.0,
                       options: .curveEaseInOut) {
            self.errorDescriptionView.layer.position.y -= 150
        } completion: { _ in
            self.isErrorDescriptionViewAnimated = false
        }
    }
}

extension LogInViewController: UITextFieldDelegate {
    // убираем/показываем клавиатуру при нажатии на view
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
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
        if textField == self.emailTextField {
            self.userLoginData.email = textField.text ?? ""
        }
        else if textField == self.passwordTextField {
            self.userLoginData.password = textField.text ?? ""
        }
        
        if self.validateEmail() {
            self.emailTextField.normalInput()
        }
        if self.validatePassword() {
            self.passwordTextField.normalInput()
        }
        
    }
    
    private func validateEmail() -> Bool {
        let emailRegex = "^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self.emailTextField.text)
    }
    
    private func validatePassword() -> Bool {
        guard let text = self.passwordTextField.text else {
            return false
        }
        
        if text.count >= 8 {
            return true
        }
        return false
    }
}

// устанавливаем констрейнты и настраиваем UI
extension LogInViewController {
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
        let _ = CGRect(origin: origin,
                                size: CGSize(width: self.frameView.frame.width + 8, height: self.frameView.frame.height + 8))
        
        let widthConstraint = 330/390 * self.view.frame.width
        let heightConstraint = 420/844 * self.view.frame.height
        
        self.frameView.center = self.view.center
        self.frameView.frame.size = CGSize(width: widthConstraint, height: heightConstraint)
    
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
        
        self.passwordTextField.keyboardType = .default
        self.passwordTextField.clearButtonMode = .never
        self.passwordTextField.textContentType = .password
        self.passwordTextField.returnKeyType = .go
        self.passwordTextField.isSecureTextEntry = true
        
        
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
        
        self.logInButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.logInButton.layer.shadowRadius = 6
    }
    
    private func setSignUpButton() {
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.titleLabel?.numberOfLines = 1
        self.signUpButton.titleLabel?.lineBreakMode = .byWordWrapping
        self.signUpButton.titleLabel?.textAlignment = .left
        
        var signUpButtonConstraints = [NSLayoutConstraint]()
        
        signUpButtonConstraints.append(
            self.signUpButton.widthAnchor.constraint(equalToConstant: 140)
        )
        
        signUpButtonConstraints.append(
            self.signUpButton.heightAnchor.constraint(equalToConstant: 45)
        )
        
        signUpButtonConstraints.append(
            self.signUpButton.leadingAnchor.constraint(equalTo: self.frameView.leadingAnchor, constant: -5)
        )
        
        signUpButtonConstraints.append(
            self.signUpButton.topAnchor.constraint(equalTo: self.frameView.topAnchor, constant: 18)
        )
        
        NSLayoutConstraint.activate(signUpButtonConstraints)
        
        self.signUpButton.transform = CGAffineTransformScale(self.signUpButton.transform, 0.5, 0.5)
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
            self.signInButton.trailingAnchor.constraint(equalTo: self.frameView.trailingAnchor, constant: -15)
        )
        
        signInButtonConstraints.append(
            self.signInButton.topAnchor.constraint(equalTo: self.frameView.topAnchor, constant: 15)
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
    
    private func setErrorDescriptionView() {
        self.view.addSubview(self.errorDescriptionView)
        self.view.bringSubviewToFront(self.errorDescriptionView)
        
        self.errorDescriptionView.frame.size = CGSize(width: 370, height: 90)
        self.errorDescriptionView.center.x = self.view.center.x
        self.errorDescriptionView.center.y = self.view.center.y - self.view.frame.height/2.0 - 45
    }
}
