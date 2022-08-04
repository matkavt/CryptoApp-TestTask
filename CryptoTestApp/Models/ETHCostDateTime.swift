//
//  ETHCostDateTime.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 03.08.2022.
//

import Foundation

/// Модель для сохранения курса в кэш
struct ETHCostDateTime: Codable {
    let dateTime: Date
    let cost: Double
}
