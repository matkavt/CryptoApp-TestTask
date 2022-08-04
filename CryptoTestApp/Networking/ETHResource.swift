//
//  ETHResource.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation

final class ETHLiveResource: APIResource {
    typealias ModelType = ETHCostResponse
    
    var time: String? // 🤔

}

final class ETHHistoricalResource: APIResource {
    typealias ModelType = ETHCostResponseForTime
    
    var time: String? // 🤔
}
