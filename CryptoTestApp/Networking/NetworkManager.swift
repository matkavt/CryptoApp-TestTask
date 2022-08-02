//
//  NetworkManager.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation

final class NetworkManager {
    private var liveRequest: ETHCostRequest<ETHLiveResource>?
    private var time: String?
    var isLoading = false
    
    func fetchLiveETHCost(with completion: @escaping (ETHCostResponse?) -> ()) {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        let resource = ETHLiveResource()
        let request = ETHCostRequest(resource: resource)
        liveRequest = request
        request.execute {response in
            DispatchQueue.main.async {
                completion(response)
                self.isLoading = false
            }
        }
    }
}
