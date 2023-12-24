//
//  NetworkCallManager.swift
//  Grates
//
//  Created by Out East on 24.12.2023.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case invalidURL
    case badRequest // 400
    case internalServerError // 500
    
    // Ошибки, связанные с регистрацией пользователя
    case unauthorized // 401
    case conflict // 409
    case notFound // 404
    
    // Ошибки связанные с постами
    case forbidden
}

enum NetworkCallMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
    case update = "UPDATE"
    case put = "PUT"
}

// TODO: Сделать абстрактный класс для запросов
class NetworkCallManager<T: Codable> {
    typealias ResponseType = T
    
    /// Отпраляет запрос, составленный с указанными параметрами
    ///
    /// * Вызывать данную функцию нужно асинхронно, чтобы она не тормозила интерфейс и анимации
    ///
    /// - Parameters:
    ///  - path: Путь до ресурса
    ///  - method: Вид запроса (GET, POST, )
    ///
    func makeRequest(forPath path: String,
                      method: NetworkCallMethod,
                      with parameters: [String: Any]?
    ) throws {
        guard let url = URL(string: path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
    }
    
//    func getRequest(_ request: URLRequest) {
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .useDefaultKeys
//        
//        let task = URLSession.shared.dataTask(with: <#T##URLRequest#>)
//    }
    
    
}
