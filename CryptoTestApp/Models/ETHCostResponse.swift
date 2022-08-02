//
//  ETHCostResponse.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation



struct ETHCostResponse: Decodable {
    let cost: Double
}

extension ETHCostResponse {
    enum CodingKeys: String, CodingKey {
        case cost = "USD"
    }
}

struct ETHCostResponseForTime: Decodable {
    let eth: Eth

    enum CodingKeys: String, CodingKey {
        case eth = "ETH"
    }
}

struct Eth: Decodable {
    let usd: Double

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}


