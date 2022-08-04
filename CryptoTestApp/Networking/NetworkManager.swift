//
//  NetworkManager.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation


final class NetworkManager {
    private var liveRequest: ETHCostRequest<ETHLiveResource>? // Я так понимаю это просто хранится, чтобы не выскочить из памяти?
    // я бы предложил сделать 1 поле-список или сэт или решить проблему по-другому, не хочется плодить по бесполезному полю для каждого запроса
    private var historicRequest: ETHCostRequest<ETHHistoricalResource>?
    private var time: String?
    var isLoading = false // пусть приватным будет лучше
    
    /// Метод для получения текущего курса
    func fetchLiveETHCost(with completion: @escaping (ETHCostResponse?) -> ()) {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        let resource = ETHLiveResource()
        let request = ETHCostRequest(resource: resource)
        liveRequest = request
        request.execute { response in
            DispatchQueue.main.async {
                completion(response)
                self.isLoading = false
            }
        }
    }
    
    /// Метод для получения курса по конкретной дате и времени
    func fetchETHCost(by date: Date, with completion: @escaping (ETHCostResponseForTime?) -> ()) {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        let resource = ETHHistoricalResource()
        resource.time = String(floor(date.timeIntervalSince1970)) // 🤔
        let request = ETHCostRequest(resource: resource)
        historicRequest = request
        request.execute { response in
            DispatchQueue.main.async {
                completion(response)
                self.isLoading = false
            }
        }
    }
}
