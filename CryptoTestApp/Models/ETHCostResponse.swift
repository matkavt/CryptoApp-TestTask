//
//  ETHCostResponse.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation

struct ETHCostResponseForTime {
    let cost: Double
}

struct ETHCostResponse: Codable {
    let cost: Double
}

extension ETHCostResponse {
    enum CodingKeys: String, CodingKey {
        case cost = "USD"
    }
}

extension ETHCostResponseForTime: Decodable {
    enum CodingKeys: String, CodingKey {
        case currency = "ETH"
        
        enum ETHKeys: String, CodingKey {
            case cost = "USD"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let costContainer = try container.nestedContainer(keyedBy: CodingKeys.ETHKeys.self, forKey: .currency)
        cost = try costContainer.decode(Double.self, forKey: .cost)
    }
}
