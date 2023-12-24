//
//  EmailConfiramtionViewController.swift
//  Grates
//
//  Created by Out East on 24.12.2023.
//

import UIKit
import RiveRuntime

class EmailConfiramtionViewController: UIViewController {
    
    private let loadingView = RiveView()
    private let loadingViewModel = RiveViewModel(fileName: "loadinganimation")
    
    private let errorDescriptionView = ErrorDescriptionView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark), errorDescription: "Your error message here.")
    private let successDescriptionView = SuccessDescriptionView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark), description: "Your message here. Your message here. Your message here. Your message here. Your message here. Your message here!")
    
    @IBOutlet weak var resendEmailButton: UIButton!
    
    // содержит id пользователя (для переотправления письма пользователю)
    var registredUserData: RegistredUserData?
    var userEmail: UserEmail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRiveView()
        self.setDescriptionViewConstraints(self.errorDescriptionView)
        self.setDescriptionViewConstraints(self.successDescriptionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animateDescriptionView(errorDescriptionView)
        DispatchQueue.global().async {
            do {
                try self.confirmRequest()
            } catch {
                self.badRequest()
            }
        }
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: UIButton) {
        DispatchQueue.global().async {
            do {
                try self.resendEmail()
            } catch {
                self.badRequest()
            }
        }
    }
    
    // Настраиваем анимацию загрузки из райва
    private func setRiveView() {
        self.loadingViewModel.setView(self.loadingView)
        self.loadingViewModel.play(animationName: "Loading", loop: .loop)
        
        self.loadingViewModel.alignment = .center
        self.loadingViewModel.fit = .fill
        
        self.view.addSubview(self.loadingView)
        self.view.sendSubviewToBack(self.loadingView)
        
        let loadingViewSize = CGSize(width: 100, height: 100)
        self.loadingView.center = CGPoint(x: self.view.center.x - loadingViewSize.width/2.0,
                                          y: self.view.center.y - loadingViewSize.height/2.0 + 150)
        self.loadingView.frame.size = loadingViewSize
    }
    
    private func confirmRequest() throws {
        guard let userEmail = self.userEmail else {
            return
        }
        let endPoint = NetworkCallInformation.Registration.checkEmail + "\(userEmail.userEmail)"
        
        guard let url = URL(string: endPoint) else {
            throw RegistrationError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                if let error = error {
                    print("Error in request: \(error)")
                    throw RegistrationError.invalidURL
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RegistrationError.invalidURL
                }
                
                if httpResponse.statusCode == 400 {
                    throw RegistrationError.badRequest
                }
                
                if httpResponse.statusCode == 400 {
                    self.succeedConfirmation()
                }
                
            } catch {
                guard let currentError = error as? RegistrationError else {
                    self.badRequest()
                    return
                }
                switch currentError {
                case .badRequest:
                    self.badRequest()
                case .userNotFound:
                    break
                case .internalServer:
                    break
                case .invalidURL:
                    self.badRequest()
                case .unauthorized:
                    break
                case .conflict:
                    break
                }
            }
        }
    }
    
    private func resendEmail() throws {
        guard let registredUserData = self.registredUserData else {
            return
        }
        let endPoint = NetworkCallInformation.Registration.resendEmail + "\(registredUserData.id)"
        guard let url = URL(string: endPoint) else {
            throw RegistrationError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        let jsonData = try encoder.encode(registredUserData)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                if let error = error {
                    print("Error in request: \(error)")
                    throw RegistrationError.invalidURL
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RegistrationError.invalidURL
                }
                
                if httpResponse.statusCode == 400 {
                    throw RegistrationError.badRequest
                } else if httpResponse.statusCode == 404 {
                    throw RegistrationError.userNotFound
                } else if httpResponse.statusCode == 500 {
                    throw RegistrationError.internalServer
                }
                
            }
            catch {
                guard let currentError = error as? RegistrationError else {
                    self.badRequest()
                    return
                }
                switch currentError {
                case .badRequest:
                    self.badRequest()
                case .userNotFound:
                    self.userNotFound()
                case .internalServer:
                    self.internalServerError()
                case .invalidURL:
                    self.badRequest()
                case .unauthorized:
                    break
                case .conflict:
                    break
                }
            }
        }
        task.resume()
    }
}
// обработка ответов запроса
extension EmailConfiramtionViewController {
    private func userNotFound() {
        DispatchQueue.main.async {
            self.errorDescriptionView.errorDescription = "User with such ID doesn't exist."
            self.animateDescriptionView(self.errorDescriptionView)
        }
    }
    
    private func badRequest() {
        DispatchQueue.main.async {
            self.errorDescriptionView.errorDescription = "Something went wrong, try again later."
            self.animateDescriptionView(self.errorDescriptionView)
        }
    }
    
    private func internalServerError() {
        DispatchQueue.main.async {
            self.errorDescriptionView.errorDescription = "Something went wrong, try again later."
            self.animateDescriptionView(self.errorDescriptionView)
        }
    }
    
    private func succeedConfirmation() {
        DispatchQueue.main.async {
            self.successDescriptionView.successDescription = "You have successfully confirmed your account!"
            self.animateDescriptionView(self.successDescriptionView)
        }
    }
    private func animateDescriptionView(_ descriptionView: UIVisualEffectView) {
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       options: .curveEaseInOut) {
            descriptionView.layer.position.y += 150
        }
        
        UIView.animate(withDuration: 0.35,
                       delay: 5.0,
                       options: .curveEaseInOut) {
            descriptionView.layer.position.y -= 150
        }
    }
}

extension EmailConfiramtionViewController {
    func setDescriptionViewConstraints(_ descriptionView: UIVisualEffectView) {
        self.view.addSubview(descriptionView)
        self.view.bringSubviewToFront(descriptionView)
        
        descriptionView.frame.size = CGSize(width: 370, height: 90)
        descriptionView.center.x = self.view.center.x
        descriptionView.center.y = self.view.center.y - self.view.frame.height/2.0 - 45
    }
}
