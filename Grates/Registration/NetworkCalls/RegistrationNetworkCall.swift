//
//  RegistrationNetworkCall.swift
//  Grates
//
//  Created by Out East on 23.12.2023.
//

import Foundation
import UIKit

struct UserData: Codable {
    var email: String = ""
    var name: String = ""
    var password: String = ""
    var surname: String = ""
}

// Get
// Post
// Put
// Update
// Delete
// Patch
enum UserDataError: Int, Error {
    case invalidURL = 1
    /// неправильно составленный запрос
    case badRequest = 2
    /// пользователь уже существует
    case conflict = 3
    /// ошибка на сервере
    case internalServer = 4
}

