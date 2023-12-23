//
//  RegistrationNetworkCall.swift
//  Grates
//
//  Created by Out East on 23.12.2023.
//

import Foundation
import UIKit

struct UserInfo: Codable {
    var email: String = ""
    var name: String = ""
    var password: String = ""
    var surname: String = ""
}

enum UserInfoError: Error {
    /// неправильно составленный запрос
    case badRequest
    /// пользователь уже существует
    case conflict
    /// ошибка на сервере
    case internalServer
}
