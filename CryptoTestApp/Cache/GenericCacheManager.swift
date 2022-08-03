//
//  GenericCashManager.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 03.08.2022.
//

import Foundation

protocol GenericCacheManager {
    associatedtype ModelType
    func saveToCache(_ model: ModelType)
    func getFromCache() -> ModelType?
    func removeFromCache()
}
