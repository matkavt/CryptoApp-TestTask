//
//  DateReceiverDelegate.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation

protocol DateTimeReceiverDelegate {
    func receiveDate(_ date: Date?) -> ()
    
    func receiveTime(_ time: Date?) -> ()
}
