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
        let decoder = JSONDecoder() // Эта штука довольно стандартная, можно было бы засунуть в APIRequestProtocol как дефолтную функцию или вообещ сделать APIRequestProtocol классом и от него наследовать
        let decoded = try? decoder.decode(Resource.ModelType.self, from: data)
        return decoded
    }
    
    func execute(_ completion: @escaping (Resource.ModelType?) -> ()) {
        // time можно наверно более умно прокидывать автоматом тут
        load(resource.url, withCompletion: completion) // аналогично
    }
}
