//
//  GenerateQrPayload.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 23/05/2024.
//

import Foundation


public struct GenerateQrPayload: Codable {
    let card_cvv, card_expiry, card_number, card_scheme, issuing_bank, app_code : String
    let email, fullname, mobile_phone, card_pin, user_id : String?
    
    enum CodingKeys: String, CodingKey {
        case card_cvv
        case card_expiry
        case card_number
        case user_id
        case card_scheme
        case issuing_bank
        case app_code
        case email
        case fullname
        case mobile_phone
        case card_pin
    }
}


public struct GenerateQrcodeResponse: Codable {
    let qr_code_id, data, card_scheme, issuing_bank, status : String?
    
    enum CodingKeys: String, CodingKey {
        case qr_code_id
        case data
        case card_scheme
        case issuing_bank
        case status
    }
}
//data:image/png;base64,




public struct EncryptedQrModelData: Codable{
    public let data: [EncryptedQrModel]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

public struct EncryptedQrModel: Codable{
        let qrcodeId: String?
        let image: String?
        //let success: Bool
        let cardScheme: String?
        let issuingBank: String?
        let date: String?
    
    enum CodingKeys: String, CodingKey {
        case qrcodeId
        case image
      //  case success
        case cardScheme
        case issuingBank
        case date
    }
}

 struct QrcodeIds: Codable {
    let qr_code_ids : [String]
    
    enum CodingKeys: String, CodingKey {
        case qr_code_ids
    }
}

