//
//  ETHCacheManager.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 03.08.2022.
//

import Foundation

/// Обобщённый класс для работы с UserDefaults
final class CostCacheManager<Resource: CacheResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension CostCacheManager: GenericCacheManager {
    /// Метод сохраняет модель данных в UserDefaults
    func saveToCache(_ model: Resource.ModelType) {
        let defaults = UserDefaults.standard
        defaults.set(try? PropertyListEncoder().encode(model), forKey: resource.key)
    }
    
    /// Метод получает модель данных из UserDefaults
    func getFromCache() -> Resource.ModelType? {
        let defaults = UserDefaults.standard
        if let saved = defaults.object(forKey: resource.key) as? Data {
            let data = try? PropertyListDecoder().decode(Resource.ModelType.self, from: saved)
            return data
        }
        
        return nil
    }
    
    /// Метод удаляет ресурс, с которым происходит обращение, из UserDefaults
    func removeFromCache() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: resource.key)
    }
}
