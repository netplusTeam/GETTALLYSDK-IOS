//
//  TokenManager.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 26/05/2024.
//

import Foundation
import Valet

class UserStore{
    
    static let shared = UserStore()
    private let valet: Valet
    private let encryptedQrModelKey = "TallySDKValetItemsEncryptedQrModelKey"
    init() {
        self.valet = Valet.valet(with: Identifier(nonEmpty: "TallySDKValetItems")!, accessibility: .afterFirstUnlock)
    }

    
    
    func readEncryptedModel() -> EncryptedQrModelData? {
        do {
            let data = try self.valet.object(forKey: encryptedQrModelKey)
            let decoder = JSONDecoder()
            return try decoder.decode(EncryptedQrModelData.self, from: data)
            
        } catch {
            try! self.clear()
            return nil
        }
    }
    
    func readEncryptedModelForSdk() -> EncryptedQrModelData? {
        do {
            let data = try self.valet.object(forKey: encryptedQrModelKey)
            let decoder = JSONDecoder()
            return try decoder.decode(EncryptedQrModelData.self, from: data)
            
        } catch {
            return nil
        }
    }
    
    func saveEncryptedModel(model: EncryptedQrModel) throws {
        var currentData = readEncryptedModel()?.data ?? []
        currentData.append(model)
        let decoder = JSONEncoder()
        let data = try decoder.encode(EncryptedQrModelData(data: currentData))
        try valet.setObject(data, forKey: encryptedQrModelKey)
        
    }
    
    
    public func clear() throws {
       try  self.valet.removeObject(forKey: encryptedQrModelKey)
    }
    
}
