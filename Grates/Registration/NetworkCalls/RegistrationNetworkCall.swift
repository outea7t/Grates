//
//  RegistrationNetworkCall.swift
//  Grates
//
//  Created by Out East on 23.12.2023.
//

import Foundation
import UIKit

// Для POST запроса на регистрацию
struct UserRegistrationData: Codable {
    var email: String = ""
    var name: String = ""
    var password: String = ""
    var surname: String = ""
}

// Если регистрация удалась, то приходит userID
struct RegistredUserData: Codable {
    var id: Int
}

// Для POST запроса на вход в соц-сеть
struct UserLoginData: Codable {
    var email: String
    var password: String
}

// Для POST запроса переотправления письма подтверждения аккаунта
struct ResendEmailData: Codable {
    var userId: Int
}

struct UserEmail: Codable {
    var userEmail: String
}

// Get
// Post
// Put
// Update
// Delete
// Patch
enum RegistrationError: Int, Error {
    case invalidURL = 1
    /// неправильно составленный запрос
    case badRequest = 400
    /// пользователь не найден
    case userNotFound = 404
    /// пользователь не зарегистрирован на сайте
    case unauthorized = 401
    /// пользователь уже существует
    case conflict = 409
    /// ошибка на сервере
    case internalServer = 500
    
}

