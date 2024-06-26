//
//  UpdatedTransactionResponse.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 26/05/2024.
//

import Foundation


 struct UpdatedTransactionResponse: Codable {
    let data: UpdatedTransactionResponseData
    let message: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case data
        case status
    }
}

 struct UpdatedTransactionResponseData: Codable {
    let count: Int
    let rows: [UpdatedTransactionResponseRow]
    
    enum CodingKeys: String, CodingKey {
        case count
        case rows
    }
}

 struct UpdatedTransactionResponseRow: Codable {
    let amount: Double
    let merchantName, responseMessage, dateCreated, rrn, agentName, localDate : String?
    let localTime_, maskedPan, merchantId, otherId, partnerId, provider, remark : String?
    let transmissionDateTime, source, terminalId, transactionTime : String?
    
    
    enum CodingKeys: String, CodingKey {
        case amount
        case merchantName
        case responseMessage
        case dateCreated
        case rrn
        case agentName
        case localDate
        case localTime_
        case maskedPan
        case merchantId
        case otherId
        case partnerId
        case provider
        case remark
        case transactionTime
        case terminalId
        case source
        case transmissionDateTime
    }
}




