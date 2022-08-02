//
//  ETHCostRequest.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation

final class ETHCostRequest<Resource: APIResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension ETHCostRequest: APIRequestProtocol {
    
    func decode(_ data: Data) -> (Resource.ModelType?) {
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode(Resource.ModelType.self, from: data)
        return decoded
    }
    
    func execute(_ completion: @escaping (Resource.ModelType?) -> ()) {
        load(resource.url, withCompletion: completion)
    }
}
