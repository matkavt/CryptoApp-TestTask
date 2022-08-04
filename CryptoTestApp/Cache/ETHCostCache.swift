//
//  ETHCostCache.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 03.08.2022.
//

import Foundation

/// Класс-обёртка над обощённым классом для работы с UserDefaults
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

// 5 файлов на кэш имхо слишком заморочено
// Такой подход наверно хорошо масштабируется и вообще SOLID все дела, но мне лично не нравится прокидывать одни и те же данные через 100500 слоёв

// Если использовать такой CostCache, то можно было бы и тут тоже generic написать

// + Всё-таки не очень понятно, зачем хранить дату и цену вместе и только в 1 месте

// Логичнее было бы отдельно хранить выбранную дату чисто чтобы при входе она выбиралась и перенести эту логику отдельно
// А в этом менеджере хранить словарик дата : цена. Тогда старые значения можно было бы тоже быстро из кэша получать. Особенно в этом кейсе, тк вероятность того, что бэк вернёт другие данные для этой же даты минимальны
