//
//  CacheResource.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 03.08.2022.
//

import Foundation

protocol CacheResource {
    associatedtype ModelType: Codable
    
    var key: String {get}
}


