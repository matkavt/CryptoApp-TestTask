//
//  APIResource.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation

/// Протокол, описывающий ресурс, который можно получить в результате запроса в сеть
protocol APIResource {
    associatedtype ModelType: Decodable
    var time: String? {get}
}

extension APIResource {
    /// URL, по которому будет происходить обращение в сеть
    var url: URL {
        var components: URLComponents
        
        if let time = time {
            components = URLComponents(string: "https://min-api.cryptocompare.com/data/pricehistorical")!
            components.queryItems = []
            components.queryItems?.append(URLQueryItem(name: "fsym", value: "ETH"))
            components.queryItems?.append(URLQueryItem(name: "tsyms", value: "USD"))
            components.queryItems?.append(URLQueryItem(name: "ts", value: time))


        } else {
            components = URLComponents(string: "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD")!
        }
        
        return components.url!
    }
}
