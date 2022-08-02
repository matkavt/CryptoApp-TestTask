//
//  APIResource.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation

protocol APIResource {
    associatedtype ModelType: Decodable
    var time: String? {get}
}

extension APIResource {
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
