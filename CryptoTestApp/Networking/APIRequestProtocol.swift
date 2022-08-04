//
//  APIRequestProtocol.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation

/// Протокол, описывающий обобщённый функционал для работы с сетью
protocol APIRequestProtocol: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func execute(_ completion: @escaping (ModelType?) -> ())
}

extension APIRequestProtocol {
    func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            guard let data = data, let decoded = self?.decode(data) else {
                completion(nil) // ошибочку мб обработать
                return
            }
            completion(decoded)
        }
        
        task.resume()
    }
}
