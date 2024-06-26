//
//  Config.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 30/04/2024.
//

import Foundation

/// TallyConfig  the configuration required to access Tally SDK
///
/// - Parameters:
///   - userId: A unique identifier for the customer, value should be unique.
///   - userFullName: The customer full name.
///   - userEmail: The customer email address
///   - userPhone: The customer phone number
///   - bankName: The name of your financial institution
///   - staging: If the test is on staging environment
///   - backgroundColor: the background color of your app.   The default is `white`
///   - textColor: the text colors of your app. The default is `black`
///   - titleFont: the fonts to use to diaplay titles. The default is `systemFont(ofSize: 18, weight: .bold)`
///   - boldFont: the fonts to use to diaplay bold character. . The default is `systemFont(ofSize: 16, weight: .bold)`
///   - mediumFont: the meidium fonts. The default is `.systemFont(ofSize: 14, weight: .medium)`
///   - regularFont: the regular fonts. The default is `.systemFont(ofSize: 14, weight: .regular)`
///   - accentColor: the accent color to use.. The default is `UIColor(red: 230/255, green: 90/255, blue: 40/255, alpha: 1.0)`
///   - accentLabelColor: the color for displaying characters on an accent color. The default is `white`
///   - apiKey: your financial institution API Key, to be collected from GetTally
///   - activationKey:  your financial institution activation Key, to gotten from your backend
///
///

public struct TallyParam {
    
    /// your user Id
    var userId: String
    /// your user full name
    var userFullName: String
    /// your user email
    var userEmail: String
    /// your user phone number
    var userPhone: String
    /// your bank name
    var bankName: String
    /// the environment
    var staging: Bool
    /// the app background color
    var backgroundColor: UIColor
    /// the app text color
    var textColor: UIColor
    /// the app text bold font
    var titleFont: UIFont
    /// the app text bold font
    var boldFont: UIFont
    /// the app text semibold font
    var semiBoldFont: UIFont
    /// the app text medium font
    var mediumFont: UIFont
    /// the app text regular font
    var regularFont: UIFont
    /// the app color for buttons and app bar
    var accentColor: UIColor
    /// the app color for texts on the accent color
    var accentLabelColor: UIColor
    /// your financial institution API Key, to be collected from GetTally
    var apiKey: String
    /// your financial institution activation Key, to gotten from your backend
    var activationKey: String
    
    func tallyConfig(token: String, merchantId: String) -> TallyConfig {
        return TallyConfig(userId: userId, userFullName: userFullName, userEmail: userEmail, userPhone: userPhone, bankName: bankName, staging: staging, backgroundColor: backgroundColor, textColor: textColor, titleFont: titleFont, boldFont: boldFont, semiBoldFont: semiBoldFont,mediumFont: mediumFont, regularFont: regularFont, accentColor: accentColor, token: token, merchantId: merchantId)
    }
    
   public init(userId: String, userFullName: String, userEmail: String, userPhone: String, bankName: String, staging: Bool, backgroundColor: UIColor = .white, textColor: UIColor = .black, titleFont: UIFont = .systemFont(ofSize: 18, weight: .bold), boldFont: UIFont = .systemFont(ofSize: 16, weight: .bold), semiBoldFont: UIFont = .systemFont(ofSize: 16, weight: .semibold), mediumFont: UIFont = .systemFont(ofSize: 14, weight: .medium), regularFont: UIFont = .systemFont(ofSize: 14, weight: .regular), accentColor: UIColor = UIColor(red: 230/255, green: 90/255, blue: 40/255, alpha: 1.0), accentLabelColor: UIColor = .white, apiKey: String, activationKey: String) {
       self.backgroundColor = backgroundColor
       self.textColor = textColor
       self.staging = staging
       self.boldFont = boldFont
       self.accentColor = accentColor
       self.userId = userId
       self.semiBoldFont = semiBoldFont
       self.mediumFont = mediumFont
       self.regularFont = regularFont
       self.titleFont = titleFont
       self.accentLabelColor = accentLabelColor
       self.userEmail = userEmail
       self.userFullName = userFullName
       self.userPhone = userPhone
       self.bankName = bankName
       self.apiKey = apiKey
       self.activationKey = activationKey
    }
    
    
    /// The function for opening the SDK Page. This should be called from the viewcontroller where is to be presented from
    /// Ensure to have added `NSPhotoLibraryAddUsageDescription` to your info.plist, else the SDK will crash.
    /// - Parameters:
    ///   - controller: The presenting controller..
    
    public func openTallySdk(controller: UIViewController){
        let vc = TallyValidatorViewController()
        vc.param = self
        if self.bankName.isEmpty{
            print("Bank Name is Empty")
            return
        }
        if self.userFullName.isEmpty{
            print("Full Name is Empty")
            return
        }
        if self.userPhone.isEmpty{
            print("Phone Number is Empty")
            return
        }
        if self.userId.isEmpty{
            print("User Id is Empty")
            return
        }
        if !self.userEmail.isValidEmail{
            print("Invalid email address")
            return
        }
        vc.modalPresentationStyle = .fullScreen
        controller.present(vc, animated: true)
       // controller.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
 struct TallyConfig {
    let  appCode = "Tally"
    /// your user Id
    var userId: String
    /// your user full name
    var userFullName: String
    /// your user email
    var userEmail: String
    /// your user phone number
    var userPhone: String
    /// your bank name
    var bankName: String
    /// the environment
    var staging: Bool
    /// the app background color
    var backgroundColor: UIColor
    /// the app text color
    var textColor: UIColor
    /// the app text bold font
    var titleFont: UIFont
    /// the app text bold font
    var boldFont: UIFont
    /// the app text semibold font
    var semiBoldFont: UIFont
    /// the app text medium font
    var mediumFont: UIFont
    /// the app text regular font
    var regularFont: UIFont
    /// the app color for buttons and app bar
    var accentColor: UIColor
    /// the app color for texts on the accent color
    var accentLabelColor: UIColor
    
    /// your user token
    var token: String
    var merchantId: String
    
   public init(userId: String, userFullName: String, userEmail: String, userPhone: String, bankName: String, staging: Bool, backgroundColor: UIColor = .white, textColor: UIColor = .black, titleFont: UIFont = .systemFont(ofSize: 18, weight: .bold), boldFont: UIFont = .systemFont(ofSize: 16, weight: .bold), semiBoldFont: UIFont = .systemFont(ofSize: 16, weight: .semibold), mediumFont: UIFont = .systemFont(ofSize: 14, weight: .medium), regularFont: UIFont = .systemFont(ofSize: 14, weight: .regular), accentColor: UIColor = UIColor(red: 230/255, green: 90/255, blue: 40/255, alpha: 1.0), accentLabelColor: UIColor = .white, token: String, merchantId: String) {
       self.backgroundColor = backgroundColor
       self.textColor = textColor
       self.staging = staging
       self.boldFont = boldFont
       self.accentColor = accentColor
       self.userId = userId
       self.semiBoldFont = semiBoldFont
       self.mediumFont = mediumFont
       self.regularFont = regularFont
       self.titleFont = titleFont
       self.accentLabelColor = accentLabelColor
       self.userEmail = userEmail
       self.userFullName = userFullName
       self.userPhone = userPhone
       self.bankName = bankName
       self.token = token
       self.merchantId = merchantId
    }
    
    
    /// The function for opening the SDK Page. This should be called from the viewcontroller where is to be presented from
    /// Ensure to have added `NSPhotoLibraryAddUsageDescription` to your info.plist, else the SDK will crash.
    /// - Parameters:
    ///   - controller: The presenting controller..
    
    public func openTallyController(controller: UIViewController){
        let vc = TallySDKViewController.fromStoryboard()
        vc.goBackToApp = {
            controller.presentingViewController?.dismiss(animated: true, completion: nil)        }
        vc.config = self
        if self.bankName.isEmpty{
            print("Bank Name is Empty")
            return
        }
        if self.userFullName.isEmpty{
            print("Full Name is Empty")
            return
        }
        if self.userPhone.isEmpty{
            print("Phone Number is Empty")
            return
        }
        if self.userId.isEmpty{
            print("User Id is Empty")
            return
        }
        if !self.userEmail.isValidEmail{
            print("Invalid email address")
            return
        }
       
        vc.modalPresentationStyle = .fullScreen
        controller.present(vc, animated: true)
        
    }
    
    
}


public class TallDataUtil{
    
    public static let shared = TallDataUtil()
    
    public func retrieveData() -> EncryptedQrModelData? {
        return UserStore.shared.readEncryptedModelForSdk()
    }
    
    public func deleteAllData() throws {
        return try UserStore.shared.clear()
    }
}


enum TallyHomeState {
    case card
    case merchant
    case token
    case transaction
}

enum TallyCardState {
    case cardSubView
    case recentSubview

}
