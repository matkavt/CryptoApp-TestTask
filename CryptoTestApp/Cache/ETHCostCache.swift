//
//  ETHCostCache.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 03.08.2022.
//

import Foundation

final class ETHCostCache {
    let manager: CostCacheManager<ETHCacheResource>
    
    init() {
        let resource = ETHCacheResource()
        manager = CostCacheManager(resource: resource)
    }
    
    func getETHCostFromCache() -> (Date, Double)? {
        let data = manager.getFromCache()
        
        guard let data = data else {
            return nil
        }
        
        return (data.dateTime, data.cost)
    }
    
    func saveETHCostToCache(dateTime: Date, cost: Double) {
        let data = ETHCostDateTime(dateTime: dateTime, cost: cost)
        manager.saveToCache(data)
    }
    
    func removeETHCostFromCache() {
        manager.removeFromCache()
    }
}
