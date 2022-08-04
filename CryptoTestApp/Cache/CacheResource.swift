//
//  CacheResource.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 03.08.2022.
//

import Foundation

/// Протокол, описывающий ресурс, который можно сохранить в кэш
protocol CacheResource {
    associatedtype ModelType: Codable
    
    /// Ключ, по которому будет организован доступ к модели данных
    var key: String {get}
}


