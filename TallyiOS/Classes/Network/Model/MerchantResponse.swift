//
//  MerchantResponse.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 06/06/2024.
//

import Foundation

// MARK: - AllMerchantsResponse
struct AllMerchantsResponse: Codable {
    let status: Bool?
    let data: [AllMerchantsResponseDatum]?
}

// MARK: - AllMerchantsResponseDatum
struct AllMerchantsResponseDatum: Codable {
    let id: Int?
    let accountNumber, contactTitle, contactName, mobilePhone: String?
    let email: String?
    let emailAlert: Bool?
    let address, terminalModelCode, bankCode, bankType: String?
    let slipHeader: String?
    let slipFooter: String?
    let businessOccupationCode, merchantCategoryCode, stateCode, visaAcquiredNumber: String?
    let verveAcquiredNumber, mastercardAcquiredNumber, terminalOwnerCode, lgaLcda: String?
    let postalCode, url, accountName: String?
    let ptsp: String?
    let partnerID: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case accountNumber = "account_number"
        case contactTitle = "contact_title"
        case contactName = "contact_name"
        case mobilePhone = "mobile_phone"
        case email
        case emailAlert = "email_alert"
        case address
        case terminalModelCode = "terminal_model_code"
        case bankCode = "bank_code"
        case bankType = "bank_type"
        case slipHeader = "slip_header"
        case slipFooter = "slip_footer"
        case businessOccupationCode = "business_occupation_code"
        case merchantCategoryCode = "merchant_category_code"
        case stateCode = "state_code"
        case visaAcquiredNumber = "visa_acquired_number"
        case verveAcquiredNumber = "verve_acquired_number"
        case mastercardAcquiredNumber = "mastercard_acquired_number"
        case terminalOwnerCode = "terminal_owner_code"
        case lgaLcda = "lga_lcda"
        case postalCode = "postal_code"
        case url
        case accountName = "account_name"
        case ptsp
        case partnerID = "partner_id"
        case createdAt, updatedAt
    }
}
