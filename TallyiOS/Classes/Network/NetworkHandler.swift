//
//  NetworkHandler.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 22/05/2024.
//

import Foundation

enum DataError: Error {
    case invalidData
    case invalidResponse
    case message(_ error: String)
}

class NetworkHandler {
    
    static let shared = NetworkHandler()

    let currency = "NGN"
    
    
    func validateKey(param: TallyParam, completion: @escaping (Result<ValidateKeyResponse, DataError>)-> ()){
        let dt: ValidateKeyRequest = .init(activationKey: param.activationKey)
        if let url = URL(string: "https://partner-auth.netpluspay.com/api/validate-activation-key") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let encoder = JSONEncoder()
            do {
              
                let data = try encoder.encode(dt)
                request.httpBody = data
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                request.setValue(
                    param.apiKey,
                    forHTTPHeaderField: "X-API-KEY"
                )
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    if let error = error {
                     
                        completion(.failure(.message(error.localizedDescription)))
                    } else if let data = data {
                        guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                            completion(.failure(.message(self.fetchErrorMessage(data: data, response: response) ?? "Error in validating activation key")))
                            return
                        }
                        
                        do {
                            let checkOutResponse = try JSONDecoder().decode(ValidateKeyResponse.self, from: data)
                            
                            completion(.success(checkOutResponse))
                        }catch {
                           
                            completion(.failure(.message(error.localizedDescription)))
                        }
                    }
                }
                task.resume()
              
            }catch {
               
                completion(.failure(.message("Error in validating activation key")))
            }
            
        }
    }

    
    func cardCheckOut(name: String, email: String, amount: Double, orderId: String, config: TallyConfig, completion: @escaping (Result<CheckOutResponse, DataError>)-> ()){
        if let url = URL(string: "https://paytally.netpluspay.com/v2/checkout?merchantId=\(config.merchantId)&currency=\(currency)&name=\(name)&email=\(email)&amount=\(amount)&orderId=\(orderId)") {
            var request = URLRequest(url: url)
            request.setValue(
                config.token,
                forHTTPHeaderField: "token"
            )
         
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    
                    completion(.failure(.message(error.localizedDescription)))
                } else if let data = data {
                    guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                       
                        completion(.failure(.message(self.fetchErrorMessage(data: data, response: response) ?? "Error in initiating checkout")))
                        return
                    }
                    
                    do {
                        let checkOutResponse = try JSONDecoder().decode(CheckOutResponse.self, from: data)
                       
                        completion(.success(checkOutResponse))
                    }catch {
                     
                        completion(.failure(.message("Error in initiating checkout")))
                    }
                }
            }
            task.resume()
        }
    }
    
    func makeVerveCardPayment(payload: PayPayload, config: TallyConfig, completion: @escaping (Result<[String: Any], DataError>)-> ()){
      
        if let url = URL(string: "https://paytally.netpluspay.com/v2/pay") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let encoder = JSONEncoder()
            do {
              
                let data = try encoder.encode(payload)
                request.httpBody = data
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                request.setValue(
                    config.token,
                    forHTTPHeaderField: "token"
                )
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    if let error = error {
                     
                        completion(.failure(.message(error.localizedDescription)))
                    } else if let data = data {
                        guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                            completion(.failure(.message(self.fetchErrorMessage(data: data, response: response) ?? "Error in initiating payment")))
                            return
                        }
                        
                        do {
                            let checkOutResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                            
                            completion(.success(checkOutResponse ?? [:]))
                        }catch {
                           
                            completion(.failure(.message(error.localizedDescription)))
                        }
                    }
                }
                task.resume()
              
            }catch {
               
                completion(.failure(.message("Error in initiating payment")))
            }
            
        }
    }
    
    func makeCardPayment(payload: PayPayload, config: TallyConfig, completion: @escaping (Result<PayResponse, DataError>)-> ()){
        
        if let url = URL(string: "https://paytally.netpluspay.com/v2/pay") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(payload)
                request.httpBody = data
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                request.setValue(
                    config.token,
                    forHTTPHeaderField: "token"
                )
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                      
                        completion(.failure(.message(error.localizedDescription)))
                    } else if let data = data {
                        guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                            completion(.failure(.message(self.fetchErrorMessage(data: data, response: response) ?? "Error in initiating payment")))
                            return
                        }
                        
                        do {
                            let checkOutResponse = try JSONDecoder().decode(PayResponse.self, from: data)
                            completion(.success(checkOutResponse))
                        }catch {
                            completion(.failure(.message(error.localizedDescription)))
                        }
                    }
                }
                task.resume()
              
            }catch {
                completion(.failure(.message("Error in initiating payment")))
            }
            
        }
        
    }
    
    func sendVerveOTP(payload: VerveOtpPayload, config: TallyConfig, result: String, provider: String, transId: String, completion: @escaping (Result<[String: Any], DataError>)-> ()){
        if let url = URL(string: "https://paytally.netpluspay.com/v2/pay") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let encoder = JSONEncoder()
            do {
                let dataFormatted = ("\(transId):\(result):\(payload.OTPData):\(provider)").toBase64()
                let formattedPayload = VerveOtpPayload(OTPData: dataFormatted, type: payload.type)
                let data = try encoder.encode(formattedPayload)
              
                request.httpBody = data
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                request.setValue(
                    config.token,
                    forHTTPHeaderField: "token"
                )
               
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                  
                    if let error = error {
                       
                        completion(.failure(.message(error.localizedDescription)))
                    } else if let data = data {
                        guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                        
                            completion(.failure(.message(self.fetchErrorMessage(data: data, response: response) ?? "Error in verifying OTP")))
                            return
                        }
                        
                        do {
                            let checkOutResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                            completion(.success(checkOutResponse ?? [:]))
                       
                        }catch {
                    
                          
                            completion(.failure(.message( "Error in verifying OTP")))
                        }
                    }
                }
                task.resume()
              
            }catch {
               
                completion(.failure(.message(error.localizedDescription)))
            }
            
        }
    }
    
    
    func generateQRCode(payload: GenerateQrPayload, config: TallyConfig, completion: @escaping (Result<GenerateQrcodeResponse, DataError>)-> ()){
        if let url = URL(string: "https://v2.getqr.netpluspay.com/qr") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let encoder = JSONEncoder()
            do {
                //token
                let data = try encoder.encode(payload)
                
                request.httpBody = data
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                request.setValue(
                    config.token,
                    forHTTPHeaderField: "token"
                )

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    if let error = error {
                       
                        completion(.failure(.message(error.localizedDescription)))
                    } else if let data = data {
                        guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                            completion(.failure(.message(self.fetchErrorMessage(data: data, response: response) ?? "Error in generating QR Code")))
                            return
                        }
                        
                        do {
                            let checkOutResponse = try JSONDecoder().decode(GenerateQrcodeResponse.self, from: data)
                            completion(.success(checkOutResponse))
                            
                        }catch {
                          
                            completion(.failure(.message("Error in generating QR Code")))
                        }
                    }
                }
                task.resume()
              
            }catch {
                completion(.failure(.message(error.localizedDescription)))
            }
            
        }
    }
    
    
    func getTransactions(payload: QrcodeIds, config: TallyConfig, completion: @escaping (Result<UpdatedTransactionResponse, DataError>)-> ()){
        if let url = URL(string: "https://device.netpluspay.com/multiple-qrcode-transactions?page=1&pageSize=20") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(payload)
                request.httpBody = data
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                request.setValue(
                    config.token,
                    forHTTPHeaderField: "token"
                )
               
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                   
                    if let error = error {
                       
                        completion(.failure(.message(error.localizedDescription)))
                    } else if let data = data {
                        guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                           
                            completion(.failure(.message(self.fetchErrorMessage(data: data, response: response) ?? "Error in fetching transactions")))
                            return
                        }
                        
                        do {
                            let checkOutResponse = try JSONDecoder().decode(UpdatedTransactionResponse.self, from: data)
                          
                            completion(.success(checkOutResponse))
                       
                        }catch {
                          
                            completion(.failure(.message("Error in fetching transactions")))
                        }
                    }
                }
                task.resume()
              
            }catch {
               
                completion(.failure(.message(error.localizedDescription)))
            }
            
        }
    }
    
    
    func fetchWebPaymentStatus(url: String, config: TallyConfig, completion: @escaping (Result<String, DataError>)-> ()){
       if let url = URL(string: url) {
           var request = URLRequest(url: url)
           request.setValue(
               config.token,
               forHTTPHeaderField: "token"
           )
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
              
               if let error = error {
                  
                   completion(.failure(.message(error.localizedDescription)))
               } else if let data = data {
                   guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                     
                       completion(.failure(.invalidResponse))
                       return
                   }
                   
                   do {
                       let checkOutResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                       completion(.success(checkOutResponse?["code"] as? String ?? ""))
                       
                   }catch {
                      
                       completion(.failure(.message(error.localizedDescription)))
                   }
               }
           }
           task.resume()
       }
   }
    
    
    
    func fetchAllMerchants(config: TallyConfig, completion: @escaping (Result<[AllMerchantsResponseDatum], DataError>)-> ()){
       if let url = URL(string: "https://contactless.netpluspay.com/user/get-partner-user?limit=20&page=1") {
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.setValue(
               "application/json",
               forHTTPHeaderField: "Content-Type"
           )
           request.setValue(
               config.token,
               forHTTPHeaderField: "token"
           )
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
              
               if let error = error {
                  
                   completion(.failure(.message(error.localizedDescription)))
               } else if let data = data {
                   guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                     
                       completion(.failure(.message(self.fetchErrorMessage(data: data, response: response) ?? "Error in fetching merchants")))
                       return
                   }
                   
                   do {
                       let checkOutResponse = try JSONDecoder().decode(AllMerchantsResponse.self, from: data)
                       completion(.success(checkOutResponse.data ?? []))
                       
                   }catch {
                      
                       completion(.failure(.message("Error in fetching merchants")))
                   }
               }
           }
           task.resume()
       }
   }
    
    private func fetchErrorMessage(data: Data?, response: URLResponse?) -> String?{
        if let response = response as? HTTPURLResponse{
            
            if response.statusCode == 401 {
                return "Unauthorized"
            }
            guard let data else { return nil}
            do {
                let checkOutResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                return checkOutResponse?["code"] as? String ?? checkOutResponse?["message"] as? String
            }catch {
                return nil
            }
            
        }else{
            return nil
        }
       
        
    }
}
