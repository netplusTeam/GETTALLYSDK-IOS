//
//  Util.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 13/05/2024.
//

import Foundation
import UIKit



extension UIViewController{
    
    static func classNameBundle() -> String {
        return "\(self)".split(separator:".").map(String.init).last!
    }
    
    func orderId () -> String{
        return UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
    
    
    func oneButtonAlert(message: String, title: String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func twoButtonAlert(message: String, title: String, ok: @escaping (UIAlertAction)-> (), cancel: @escaping (UIAlertAction)-> ()){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: ok))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: cancel))

        self.present(alert, animated: true, completion: nil)
    }
    
    
    func createClientDataForNonVerveCard( transID: String, cardNumber: String, expiryDate: String, cvv: String) -> String {
        return "\(transID):LIVE:\(cardNumber):\(expiryDate):\(cvv)::NGN:QR"
    }
    

    func createClientDataForVerveCard( generateQrPayload: GenerateQrPayload, transID: String) -> String {
        let verve = "\(transID):LIVE:\(generateQrPayload.card_number):\(generateQrPayload.card_expiry):\(generateQrPayload.card_cvv):\(generateQrPayload.card_pin ?? ""):NGN:QR"
        return verve
    }
    
}
