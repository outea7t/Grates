//
//  Data.swift
//  Grates
//
//  Created by Out East on 25.12.2023.
//

import Foundation
import UIKit

/// Токены для получения информации о пользователе
struct Tokens: Codable {
    var accessToken: String
    var refreshToken: String
}

/// Сохраненные токены на устройстве пользователя
/// Так как они и так приходят в зашифрованном виде, то мы не будем их шифровать еще раз
struct UserTokens {
    /// чтобы не прописывать каждый раз строчки ключей мы выносим их в отдельное перечисление
    private enum UserTokensKeys: String {
        case accessToken
        case refreshToken
    }
    
    
    public static var userAccessToken: String {
        get {
            return UserDefaults.standard.string(forKey: UserTokensKeys.accessToken.rawValue) ?? ""
        }
        set {
            let defaults = UserDefaults.standard
            defaults.setValue(newValue, forKey: UserTokensKeys.accessToken.rawValue)
        }
    }
    
    public static var userRefreshToken: String {
        get {
            return UserDefaults.standard.string(forKey: UserTokensKeys.refreshToken.rawValue) ?? ""
        }
        set {
            let defaults = UserDefaults.standard
            defaults.setValue(newValue, forKey: UserTokensKeys.refreshToken.rawValue)
        }
    }
}
