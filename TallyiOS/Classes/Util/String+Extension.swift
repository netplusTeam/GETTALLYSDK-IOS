//
//  String+Extension.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 01/05/2024.
//

import Foundation

extension String{
    
    func returnCardType() -> String{
        let visa =  "^4[0-9]{6,}$"//"^4[0-9]{12}(?:[0-9]{3,4})?$"//
        let visa_local = "^4[19658][7684][0785][04278][128579](?:[0-9]{10})$"
        let mastercard = "^5[1-5][0-9]{5,}$" //"^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
        let mastercard_local = "^(?:5[13]99|55[35][19]|514[36])(?:11|4[10]|23|83|88)(?:[0-9]{10})$"
        let verve = "^5[0-9]{6,}$"//"^(?:50[067][180]|6500)(?:[0-9]{15})$"
      //  let american_exp = "^3[47][0-9]{5,}$"//"^3[47](?:[0-9]{13})$"
       // let discover = "^5[0-9]{6,}$"//"^6(?:011|4[4-9]3|222|5[0-9]{2})[0-9]{12}$"
       // let unionPay = "^(62|88)[0-9]{5,}$"
    /*    if self.isValidRegex(american_exp){
            return "america_express"
        }
        if self.isValidRegex(discover){
            return "discover"
        }*/
        if self.isValidRegex(mastercard) || self.isValidRegex(mastercard_local){
            return "mastercard"
        }
        if self.isValidRegex(verve){
            return "verve"
        }
        if self.isValidRegex(visa) || self.isValidRegex(visa_local){
            return "visa"
        }
     /*   if self.isValidRegex(unionPay){
            return "unionpay"
        }*/
        
        return "creditCard"
    }
    
    
    
    
    func getScheme() -> String{
        let visa =  "^4[0-9]{6,}$"//"^4[0-9]{12}(?:[0-9]{3,4})?$"//
        let visa_local = "^4[19658][7684][0785][04278][128579](?:[0-9]{10})$"
        let mastercard = "^5[1-5][0-9]{5,}$" //"^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
        let mastercard_local = "^(?:5[13]99|55[35][19]|514[36])(?:11|4[10]|23|83|88)(?:[0-9]{10})$"
        let verve = "^5[0-9]{6,}$"//"^(?:50[067][180]|6500)(?:[0-9]{15})$"
      //  let american_exp = "^3[47][0-9]{5,}$"//"^3[47](?:[0-9]{13})$"
      //  let discover = "^5[0-9]{6,}$"//"^6(?:011|4[4-9]3|222|5[0-9]{2})[0-9]{12}$"
       // let unionPay = "^(62|88)[0-9]{5,}$"
      /*  if self.isValidRegex(american_exp){
            return "American Express"
        }
        if self.isValidRegex(discover){
            return "Discover"
        }*/
        if self.isValidRegex(mastercard) || self.isValidRegex(mastercard_local){
            return "MasterCard"
        }
        if self.isValidRegex(verve){
            return "Verve"
        }
        if self.isValidRegex(visa) || self.isValidRegex(visa_local){
            return "Visa"
        }
     /*   if self.isValidRegex(unionPay){
            return "unionpay"
        }*/
        
        return "Unknown"
    }
    func isValidRegex(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func isValidExpiryDate() -> Bool {
        let theMonthEntered = "\(self.prefix(2))"
        let theYearEntered = "\(self.suffix(2))"
        guard let theMonth = Int(theMonthEntered) else { return false }
        guard let theYear = Int(theYearEntered) else { return false }
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = "\(calendar.component(.year, from: currentDate))".suffix(2)
        let currentMonth = calendar.component(.month, from: currentDate)
        guard let theCurrentYear = Int(currentYear) else { return false }
      
        return theYear > theCurrentYear || (theYear == theCurrentYear && theMonth >= currentMonth)
    }
    
    public var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return isValidRegex(regex)
    }
    
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    public func dateFromISOString() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent // TimeZone(secondsFromGMT: 0)!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self)
    }
    
    public func stringFromDate() -> String {
        if let date = self.dateFromISOString(){
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            
           // dateFormatter.dateFormat = "dd MMMM yyyy, HH:mm" // 24 hour
            dateFormatter.dateFormat = "dd MMMM yyyy, h:mm a"
            return dateFormatter.string(from: date)
        }
        return ""
      
    }
    
    func convertBase64StringToImage() -> UIImage? {
        let imageData = Data(base64Encoded: self) ?? Data()
        let image = UIImage(data: imageData)
        return image
    }
    
}
extension Double {
    
    public func formatPrice() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.currencySymbol = "₦"
        currencyFormatter.locale = Locale(identifier: "en_US")
        let currencyString = currencyFormatter.string(from: NSNumber(value: self))
        return (currencyString ?? "").replacingOccurrences(of: " ", with: "")
    }
}



