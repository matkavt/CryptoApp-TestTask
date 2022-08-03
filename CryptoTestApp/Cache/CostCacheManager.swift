//
//  ETHCacheManager.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 03.08.2022.
//

import Foundation

final class CostCacheManager<Resource: CacheResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension CostCacheManager: GenericCacheManager {
    func saveToCache(_ model: Resource.ModelType) {
        let defaults = UserDefaults.standard
        defaults.set(try? PropertyListEncoder().encode(model), forKey: resource.key)
    }
    
    func getFromCache() -> Resource.ModelType? {
        let defaults = UserDefaults.standard
        if let saved = defaults.object(forKey: resource.key) as? Data {
            let data = try? PropertyListDecoder().decode(Resource.ModelType.self, from: saved)
            return data
        }
        
        return nil
    }
    
    func removeFromCache() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: resource.key)
    }
}
