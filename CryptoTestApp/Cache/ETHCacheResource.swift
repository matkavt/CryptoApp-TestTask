//
//  ETHCacheResource.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 03.08.2022.
//

import Foundation

/// Ресурс, описывающий модель данных курса ETH и ключ для работы с User Defaults
final class ETHCacheResource: CacheResource {
    typealias ModelType = ETHCostDateTime
    
    /// Ключ для обращения к данным в UserDefaults
    var key = "ETH_Cache"
}
