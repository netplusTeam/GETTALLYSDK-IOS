//
//  TallySDKAddCardViewController.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 01/05/2024.
//

import UIKit
import WebKit

class TallySDKAddCardViewController: UIViewController, StoryboardLoadable, ProgressDisplayableControllerProtocol, WKUIDelegate, WKScriptMessageHandler {
    
    
    var progressIndicatorView: ProgressIndicatorView = ProgressIndicatorView()
    var config: TallyConfig!
    
    var qrCodeGenerated: ((EncryptedQrModel?) -> ())?


    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardYearTextField: UITextField!
    @IBOutlet weak var cardMonthTextField: UITextField!
    @IBOutlet weak var cardCVVTextField: UITextField!
    
    @IBOutlet weak var cardTypeImage: UIImageView!
   
    
    @IBOutlet weak var cardExpireLabel: UILabel!
    @IBOutlet weak var cardCVVLabel: UILabel!
    @IBOutlet weak var cardHeadingLabel: UILabel!
    @IBOutlet weak var cardSubHeadingLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    @IBOutlet weak var blurBkgView: UIView!
    
    @IBOutlet weak var pinBottomView: UIView!
    @IBOutlet weak var pinBottomViewLabel: UILabel!
    @IBOutlet weak var continuePINButton: UIButton!
    
    @IBOutlet weak var continueOTPButton: UIButton!
    @IBOutlet weak var otpBottomView: UIView!
    @IBOutlet weak var otpTextField: UITextField!
    
    @IBOutlet weak var pin1TextField: UITextField!
    @IBOutlet weak var pin2TextField: UITextField!
    @IBOutlet weak var pin3TextField: UITextField!
    @IBOutlet weak var pin4TextField: UITextField!
    
    var webView = WKWebView()
    var headerView = UIView()
    @IBOutlet weak var webSuperView: UIView!
    @IBOutlet weak var webSuperViewCancelButton: UIButton!
    var progressView = UIProgressView()
    
    var textColroView: [UIView] = []
    
    var cardNum: String = ""
    var cardYear = ""
    var cardMnth: String = ""
    var cardCVV = ""
    var cardPIN: String? = nil
    var cardOTP: String? = nil
    var cardType: String = ""
    
    var transactionId = ""
    var result = ""
    var provider = ""
    
    var fired = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = config.backgroundColor
        self.webSuperView.backgroundColor = config.backgroundColor
        addWebView()
        cardNumberTextField.delegate = self
        cardYearTextField.delegate = self
        cardMonthTextField.delegate = self
        cardCVVTextField.delegate = self
        
        pin1TextField.delegate = self
        pin2TextField.delegate = self
        pin3TextField.delegate = self
        pin4TextField.delegate = self
        
        cardNumberTextField.layer.borderColor = config.textColor.cgColor
        cardYearTextField.layer.borderColor = config.textColor.cgColor
        cardMonthTextField.layer.borderColor = config.textColor.cgColor
        cardCVVTextField.layer.borderColor = config.textColor.cgColor
        
        pin1TextField.layer.borderColor = config.textColor.cgColor
        pin2TextField.layer.borderColor = config.textColor.cgColor
        pin3TextField.layer.borderColor = config.textColor.cgColor
        pin4TextField.layer.borderColor = config.textColor.cgColor
        otpTextField.layer.borderColor = config.textColor.cgColor
        
        cardSubHeadingLabel.textColor = config.accentColor
        pinBottomViewLabel.textColor = config.textColor
        
        cardNumberTextField.layer.borderWidth = 1.0
        cardYearTextField.layer.borderWidth = 1.0
        cardMonthTextField.layer.borderWidth = 1.0
        cardCVVTextField.layer.borderWidth = 1.0
        
        pin1TextField.layer.borderWidth = 1.0
        pin2TextField.layer.borderWidth = 1.0
        pin3TextField.layer.borderWidth = 1.0
        pin4TextField.layer.borderWidth = 1.0
        otpTextField.layer.borderWidth = 1.0
        
        
        cardNumberTextField.setCornerRadius(8.0)
        cardYearTextField.setCornerRadius(8.0)
        cardMonthTextField.setCornerRadius(8.0)
        cardCVVTextField.setCornerRadius(8.0)
        
        pin1TextField.setCornerRadius(4.0)
        pin2TextField.setCornerRadius(4.0)
        pin3TextField.setCornerRadius(4.0)
        pin4TextField.setCornerRadius(4.0)
        otpTextField.setCornerRadius(8.0)
        
        pinBottomView.setCornerRadius(20.0)
        otpBottomView.setCornerRadius(20.0)
        
        cardNumberTextField.textColor = config.textColor
        cardYearTextField.textColor = config.textColor
        cardMonthTextField.textColor = config.textColor
        cardCVVTextField.textColor = config.textColor
        cardHeadingLabel.textColor = config.textColor
        cardCVVLabel.textColor = config.textColor
        cardExpireLabel.textColor = config.textColor
        pin1TextField.textColor = config.textColor
        pin2TextField.textColor = config.textColor
        pin3TextField.textColor = config.textColor
        pin4TextField.textColor = config.textColor
        otpTextField.textColor = config.textColor
        
        
        cardNumberTextField.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        continueButton.backgroundColor = config.accentColor
        continueButton.setTitleColor(config.backgroundColor, for: .normal)
        continueButton.titleLabel?.font = config.semiBoldFont
        continueButton.setCornerRadius(8)
        
        continuePINButton.backgroundColor = config.accentColor
        continuePINButton.setTitleColor(config.backgroundColor, for: .normal)
        continuePINButton.titleLabel?.font = config.semiBoldFont
        continuePINButton.setCornerRadius(8)
        
        continuePINButton.backgroundColor = config.backgroundColor
        continuePINButton.setTitleColor(config.textColor, for: .normal)
        continuePINButton.titleLabel?.font = config.semiBoldFont
        continuePINButton.setCornerRadius(8)
        continuePINButton.layer.borderWidth = 1.0
        
        continueOTPButton.backgroundColor = config.backgroundColor
        continueOTPButton.setTitleColor(config.textColor, for: .normal)
        continueOTPButton.titleLabel?.font = config.semiBoldFont
        continueOTPButton.setCornerRadius(8)
        continueOTPButton.layer.borderWidth = 1.0
        
        webSuperViewCancelButton.backgroundColor = config.backgroundColor
        webSuperViewCancelButton.setTitleColor(config.textColor, for: .normal)
        webSuperViewCancelButton.titleLabel?.font = config.semiBoldFont
       // continueOTPButton.setCornerRadius(8)
      // continueOTPButton.layer.borderWidth = 1.0
        
        

        // Do any additional setup after loading the view.
    }
    
    private func addWebView() {
        let viewportScriptString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); meta.setAttribute('initial-scale', '1.0'); meta.setAttribute('maximum-scale', '1.0'); meta.setAttribute('minimum-scale', '1.0'); meta.setAttribute('user-scalable', 'no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let disableSelectionScriptString = "document.documentElement.style.webkitUserSelect='none';"
        let disableCalloutScriptString = "document.documentElement.style.webkitTouchCallout='none';"
        
        let viewportScript = WKUserScript(source: viewportScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let disableSelectionScript = WKUserScript(source: disableSelectionScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let disableCalloutScript = WKUserScript(source: disableCalloutScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let controller = WKUserContentController()
        
        controller.addUserScript(viewportScript)
        controller.addUserScript(disableSelectionScript)
        controller.addUserScript(disableCalloutScript)
        controller.add(self, name: "iosListener")

        let config = WKWebViewConfiguration()
        config.userContentController = controller
        
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.preferences.javaScriptEnabled = true
        
        webView = WKWebView(frame: webSuperView.frame, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.configuration.preferences.javaScriptEnabled = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        webSuperView.addSubview(webView)
        webSuperView.addSubview(progressView)
        webView.topAnchor.constraint(equalTo: webSuperView.topAnchor, constant: 70).isActive = true
        webView.bottomAnchor.constraint(equalTo: webSuperView.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: webSuperView.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: webSuperView.trailingAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: webSuperView.topAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: webSuperView.bottomAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: webSuperView.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: webSuperView.trailingAnchor).isActive = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
        
    private func addPopUpWebView(configuration: WKWebViewConfiguration) -> WKWebView {
        let webView = WKWebView(frame: webSuperView.bounds, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webSuperView.addSubview(webView)
        webView.topAnchor.constraint(equalTo: webSuperView.topAnchor, constant: 70).isActive = true
        webView.bottomAnchor.constraint(equalTo: webSuperView.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: webSuperView.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: webSuperView.trailingAnchor).isActive = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }
    
    private func loadUrl(url: String){
        fired = 0
        self.webView.loadHTMLString(url, baseURL: nil)
        webView.allowsBackForwardNavigationGestures = true
        webSuperView.isHidden = false
    }
    
    @IBAction func cardNumberFieldDidChange(_ sender: UITextField){
        if sender.text?.replacingOccurrences(of: " ", with: "").count == 16{
            cardMonthTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func cardMonthFieldDidChange(_ sender: UITextField){
        if sender.text?.count == 2{
            cardYearTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func cardYearFieldDidChange(_ sender: UITextField){
        if sender.text?.count == 2{
            cardCVVTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func cardCVVFieldDidChange(_ sender: UITextField){
        if sender.text?.count == 3{
            cardCVVTextField.resignFirstResponder()
        }
    }
    
    @IBAction func cardPIN1FieldDidChange(_ sender: UITextField){
        if sender.text?.count == 1{
            pin2TextField.becomeFirstResponder()
        }
    }
    
    @IBAction func cardPIN2FieldDidChange(_ sender: UITextField){
        if sender.text?.count == 1{
            pin3TextField.becomeFirstResponder()
        }
    }
    
    @IBAction func cardPIN3FieldDidChange(_ sender: UITextField){
        if sender.text?.count == 1{
            pin4TextField.becomeFirstResponder()
        }
    }
    
    @IBAction func cardPIN4FieldDidChange(_ sender: UITextField){
        if sender.text?.count == 1{
            pin4TextField.resignFirstResponder()
        }
    }
    
    
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: false)
            }
          /*
            if let key = change?[NSKeyValueChangeKey.newKey] {
       
                let urlString = "\(key)"
                if let url = URL(string: urlString){
                  
                }
            }*/
        }
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
       
          return addPopUpWebView(configuration: configuration)
        
        
      }
    
    private func fetchWebPaymentStatus(){
        let fetchResponseUrl = "https://paytally.netpluspay.com/transactions/requery/MID63dbdc67badab/\(transactionId)"
        NetworkHandler.shared.fetchWebPaymentStatus(url: fetchResponseUrl, config: config, completion: {[weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let success):
                switch success{
                case "00":
                    DispatchQueue.main.async {
                        self.hideProgress()
                        self.dismissAllBottom()
                        self.generateQRCode()
                    }
                    
                case "80",  "90":
                    DispatchQueue.main.async {
                        self.hideProgress()
                        self.dismissAllBottom()
                        self.oneButtonAlert(message: "Unable to charge card, please try again", title: "Error")
                    }
                default:
                    break
                }
            case .failure(let failure):
                var message = ""
                switch failure{
                case .invalidData:
                    message = failure.localizedDescription
                case .invalidResponse:
                    message = failure.localizedDescription
                case .message(let e):
                    message = e
                }
                print(message)
              /*  DispatchQueue.main.async {
                    self.oneButtonAlert(message: "Error in charging card", title: "Error")
                }*/
            }
        })
    }
      
      public func webViewDidClose(_ webView: WKWebView) {
          webView.removeFromSuperview()
          dismissAllBottom()
      }
    
    @IBAction private func onCancelTapped(){
        dismissPopUpView()
    }
    
    @IBAction private func continueOTPAction(){
        cardOTP = otpTextField.text?.replacingOccurrences(of: " ", with: "")
        guard let cardOTP else {
            oneButtonAlert(message: "Invalid OTP", title: "Error")
            return
        }
        guard !cardOTP.isEmpty else {
            oneButtonAlert(message: "Invalid OTP", title: "Error")
            return
        }
        guard cardOTP.count == 6 else {
            oneButtonAlert(message: "Invalid OTP", title: "Error")
            return
        }
        showProgress(config: config, message: "Processing..")
        NetworkHandler.shared.sendVerveOTP(payload: .init(OTPData: cardOTP, type: "OTP"), config: config, result: result, provider: provider, transId: transactionId, completion: {[weak self] result in
            guard let self else{
                return
            }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let code = response["code"] as? String{
                        if code == "00"{
                            self.generateQRCode()
                        }else{
                            self.hideProgress()
                            self.oneButtonAlert(message: "Transaction Failed", title: "Error")
                        }
                    }
                  
                }
          
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.clearForm()
                    self.hideProgress()
                }
                var message = ""
                switch failure{
                case .invalidData:
                    message = failure.localizedDescription
                case .invalidResponse:
                    message = failure.localizedDescription
                case .message(let e):
                    message = e
                }
                DispatchQueue.main.async {
                    self.oneButtonAlert(message: message, title: "Error")
                }
            }
        })
    }
    
    private func encryptCard(data: GenerateQrcodeResponse?){
        dismissAllBottom()
        if let data{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM YYYY"
            let dateString = dateFormatter.string(from: Date())
            let encrypted = EncryptedQrModel(qrcodeId: data.qr_code_id, image: data.data?.replacingOccurrences(of: "data:image/png;base64,", with: "").replacingOccurrences(of: "data:image/jpeg;base64,", with: ""), cardScheme: data.card_scheme, issuingBank: data.issuing_bank, date: dateString)
            do {
                try  UserStore.shared.saveEncryptedModel(model: encrypted)
                self.qrCodeGenerated?(encrypted)
            }catch {
                oneButtonAlert(message: "Failed to save QR code", title: "Error")
            }
          
        }
    }
    
    func generateQRCode(){
        let expiryDate = "\(cardMnth)\(cardYear)"
        let payload: GenerateQrPayload = .init(card_cvv: cardCVV, card_expiry: expiryDate, card_number: cardNum, card_scheme: cardType, issuing_bank: config.bankName, app_code: config.appCode, email: config.userEmail, fullname: config.userFullName, mobile_phone: config.userPhone, card_pin: cardPIN, user_id: config.userId)
        showProgress(config: config, message: "Saving Card ....")
        NetworkHandler.shared.generateQRCode(payload: payload, config: config, completion: {[weak self] result in
            guard let self else{
                self?.clearForm()
                self?.hideProgress()
                return
            }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.clearForm()
                    self.hideProgress()
                    self.clearForm()
                    self.encryptCard(data: success)
                }
               
                
            case .failure(let failure):
                
                var message = ""
                switch failure{
                case .invalidData:
                    message = failure.localizedDescription
                case .invalidResponse:
                    message = failure.localizedDescription
                case .message(let e):
                    message = e
                }
                DispatchQueue.main.async {
                    self.clearForm()
                    self.hideProgress()
                    self.clearForm()
                    self.oneButtonAlert(message: message, title: "Error")
                }
               
            }
        })
    }
    
    @IBAction private func continuePINAction(){
        let pin1 = pin1TextField.text ?? ""
        let pin2 = pin2TextField.text ?? ""
        let pin3 = pin3TextField.text ?? ""
        let pin4 = pin4TextField.text ?? ""
        let pin = "\(pin1)\(pin2)\(pin3)\(pin4)"
        cardPIN = pin
        if pin.count < 4 {
            cardPIN = nil
            oneButtonAlert(message: "Error", title: "PIN length is too short")
        }else{
            cardCheckOut()
        }
    }
    
    private func cardCheckOut(){
        showProgress(config: config, message: "Tokenizing card...")
      
        NetworkHandler.shared.cardCheckOut(name: config.userFullName, email: config.userEmail, amount: config.staging ? 100.0 : 100.0, orderId: orderId(), config: config, completion: {[weak self] result in
            guard let self else{
                self?.oneButtonAlert(message: "", title: "unknown error")
                return
            }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.makePayment(data: data)
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.clearForm()
                    self.hideProgress()
                }
                var message = ""
                switch failure{
                case .invalidData:
                    message = failure.localizedDescription
                case .invalidResponse:
                    message = failure.localizedDescription
                case .message(let e):
                    message = e
                }
                DispatchQueue.main.async {
                    self.oneButtonAlert(message: message, title: "Error")
                }
           
                
            }
            
        })

    }
    
    private func makePayment(data: CheckOutResponse){
        let expiryDate = "\(cardMnth)\(cardYear)"
        let generateQrPayload: GenerateQrPayload = .init(card_cvv: cardCVV, card_expiry: expiryDate, card_number: cardNum, card_scheme: cardType, issuing_bank: config.bankName, app_code: config.appCode, email: config.userEmail, fullname: config.userFullName, mobile_phone: config.userPhone, card_pin: cardPIN, user_id: config.userId)
        var clientDataString = ""
        if cardType.lowercased() == "Verve".lowercased(){
            clientDataString = createClientDataForVerveCard(generateQrPayload: generateQrPayload, transID: data.transId)
        }else{
            clientDataString = createClientDataForNonVerveCard(transID: data.transId, cardNumber: cardNum, expiryDate: expiryDate, cvv: cardCVV)
        }
        let base64String = clientDataString.toBase64().replacingOccurrences(of: "\n", with: "")
        let payPayload = PayPayload(clientData: base64String, type: "PAY")
        if let cardPIN{
            if !cardPIN.isEmpty{
                NetworkHandler.shared.makeVerveCardPayment(payload: payPayload, config: config, completion: {[weak self] result in
                    guard let self else{
                        self?.oneButtonAlert(message: "", title: "unknown error")
                        return
                    }
                    switch result {
                    case .success(let data):
                        switch (data["code"] as? String){
                        case "1":
                            DispatchQueue.main.async {[weak self] in
                                self?.hideProgress()
                                self?.dismissAllBottom()
                                self?.oneButtonAlert(message: "There was an error processing this transaction", title: "Error")
                            }
                        case "80":
                            break
                        case "90":
                            break
                        default:
                            DispatchQueue.main.async {[weak self] in
                                self?.transactionId = data["transId"] as? String ?? ""
                                self?.result = data["result"] as? String ?? ""
                                self?.provider = data["provider"] as? String ?? ""
                                self?.hideProgress()
                                self?.pinBottomView.isHidden = true
                                self?.otpBottomView.isHidden = false
                                self?.blurBkgView.isHidden = false
                            }
                        }
                   
                    case .failure(let failure):
                        DispatchQueue.main.async {[weak self] in
                            self?.hideProgress()
                            self?.dismissAllBottom()
                        }
                        var message = ""
                        switch failure{
                        case .invalidData:
                            message = failure.localizedDescription
                        case .invalidResponse:
                            message = failure.localizedDescription
                        case .message(let e):
                            message = e
                        }
                        DispatchQueue.main.async {[weak self] in
                            self?.oneButtonAlert(message: message, title: "Error")
                        }
                        
                    }
                    
                })
            }
        }else{
            
            NetworkHandler.shared.makeCardPayment(payload: payPayload, config: config, completion: {[weak self] result in
                guard let self else{
                    self?.oneButtonAlert(message: "", title: "unknown error")
                    return
                }
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {[weak self] in
                        self?.hideProgress()
                       
                        self?.transactionId = data.transId
                        self?.loadUrl(url: data.redirectHtml)
                    }
                   
                    break
                case .failure(let failure):
                    self.hideProgress()
                    var message = ""
                    switch failure{
                    case .invalidData:
                        message = failure.localizedDescription
                    case .invalidResponse:
                        message = failure.localizedDescription
                    case .message(let e):
                        message = e
                    }
                    DispatchQueue.main.async {[weak self] in
                        self?.oneButtonAlert(message: message, title: "Error")
                    }
                    
                }
            })
        }
        
    }
    
    @IBAction private func dismissBakAction(){
        dismissPopUpView()
    }
    
    private func dismissPopUpView(){
        twoButtonAlert(message: "Caution", title: "Do you want to cancel QR Code Generation", ok: { [weak self] _ in
            guard let self else {
                return
            }
            self.dismissAllBottom()
        }, cancel: {_ in
            
            
        })
    }
    
    private func dismissAllBottom(){
        self.otpBottomView.isHidden = true
        self.pinBottomView.isHidden = true
        self.blurBkgView.isHidden = true
        self.webSuperView.isHidden = true
        clearForm()
    }
    
    
    private func clearForm(){
        DispatchQueue.main.async {[weak self] in
            guard let self else{
                return
            }
            self.cardMonthTextField.text = ""
            self.cardYearTextField.text = ""
            self.cardNumberTextField.text = ""
            self.cardCVVTextField.text = ""
            self.otpTextField.text = ""
            self.pin1TextField.text = ""
            self.pin2TextField.text = ""
            self.pin3TextField.text = ""
            self.pin4TextField.text = ""
        }
       
        
    }
    
    @IBAction private func continueButtonAction(){
        cardNum = ""
        cardCVV = ""
        cardYear = ""
        cardMnth = ""
        cardPIN = nil
        cardOTP = nil
        cardType = ""
        
        let cardNumber = cardNumberTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let expYear = cardYearTextField.text ?? ""
        let expMonth = cardMonthTextField.text ?? ""
        let cvv = cardCVVTextField.text ?? ""
        let expireDate = "\(expMonth)\(expYear)"
        cardNum = cardNumber
        cardCVV = cvv
        cardYear = expYear
        cardMnth = expMonth
        
        if cardNumber.isEmpty{
            oneButtonAlert(message: "Error", title: "Card number cannot be empty")
        }else if expMonth.isEmpty{
            oneButtonAlert(message: "Error", title: "Expiry month cannot be empty")
        }else if expYear.isEmpty{
            oneButtonAlert(message: "Error", title: "Expiry year cannot be empty")
        }else if cvv.isEmpty{
            oneButtonAlert(message: "Error", title: "CVV cannot be empty")
        }else if !expireDate.isValidExpiryDate(){
            oneButtonAlert(message: "Error", title: "Invalid expiry date")
        }else{
            twoButtonAlert(message: "Your card will be charged 100 NGN for tokenization", title: "", ok: {
                [weak self] _ in
                guard let self  else { return  }
                self.chargeCardByType(cardNumber: cardNumber, expYear: expYear, expMonth: expMonth, cvv: cvv)
            }, cancel: {
                _ in
            })
           
        }
    }
    
    private func chargeCardByType(cardNumber: String, expYear: String, expMonth: String, cvv: String){
        self.cardType = cardNumber.getScheme()
        let cardType = cardNumber.getScheme()
        if cardType.lowercased() == "Visa".lowercased(){
            cardCheckOut()

        }
        if cardType.lowercased() == "MasterCard".lowercased(){
            cardCheckOut()
        }
        
        if cardType.lowercased() == "Verve".lowercased(){
            otpBottomView.isHidden = true
            blurBkgView.isHidden = false
            pinBottomView.isHidden = false
        }
        
        
    }
    
   
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 19 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertSpacesEveryFourDigitsIntoString(string: cardNumberWithoutSpaces, andPreserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }

    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }

    func insertSpacesEveryFourDigitsIntoString(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            if i > 0 && (i % 4) == 0 {
                stringWithAddedSpaces.append(contentsOf: " ")
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "iosListener" {
          
           // fetchWebPaymentStatus()
           // let response = message.body
          
           
          /*  if let bodyDict = response as? [String : Any] {
                guard let event  = bodyDict["event"] as? String else { return }
                switch event {
                case "success":
                    dismissAllBottom()
                    oneButtonAlert(message: "Successs", title: "Was succesful")
                        
                default:
                   break
                }
            }*/
            
        }
        

       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TallySDKAddCardViewController: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
      
       
        if textField == cardNumberTextField {
            previousTextFieldContent = textField.text;
            previousSelection = textField.selectedTextRange;
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            let formttedNumber = newString.replacingOccurrences(of: " - ", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
           // cardTypeImage.image = loadImage(name: formttedNumber.returnCardType())
            switch formttedNumber.returnCardType().lowercased(){
            case "discover":
                cardTypeImage.image = UIImage.bundledImage(named: "discover")
            case "mastercard":
                cardTypeImage.image = UIImage.bundledImage(named: "mastercard")
            case "verve":
                cardTypeImage.image = UIImage.bundledImage(named: "verve")
            case "visa":
                cardTypeImage.image = UIImage.bundledImage(named: "visa")
            case "unionpay":
                cardTypeImage.image = UIImage.bundledImage(named: "unionpay")
            default:
                cardTypeImage.image = UIImage.bundledImage(named: "creditCard")
            }
            
            if formttedNumber.count == 25{
               // cardMonthTextField.becomeFirstResponder()
            }
        }
        
        if  textField == pin1TextField || textField == pin2TextField || textField == pin3TextField || textField == pin4TextField {
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            if (newString.count == 2){
                if (textField == pin1TextField){
                  //  pin2TextField.becomeFirstResponder()
                }
                if (textField == pin2TextField){
                  //  pin3TextField.becomeFirstResponder()
                }
                if (textField == pin3TextField){
                   // pin4TextField.becomeFirstResponder()
                }
                if (textField == pin4TextField){
                  //  pin4TextField.resignFirstResponder()
                }
            }
          
            return (newString.count <= 2)
        }
        
        if textField == cardMonthTextField || textField == cardYearTextField || textField == cardCVVTextField{
            let maxLength = textField == cardCVVTextField ? 4 : 3
            
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            if (newString.count == maxLength  && allowedCharacters.isSuperset(of: characterSet)){
                if (textField == cardMonthTextField){
                    //cardYearTextField.becomeFirstResponder()
                }
                if (textField == cardYearTextField){
                  //  cardCVVTextField.becomeFirstResponder()
                }
                if (textField == cardCVVTextField){
                  //  cardCVVTextField.resignFirstResponder()
                }
            }
            
            return allowedCharacters.isSuperset(of: characterSet) && (newString.count <= maxLength)
        }
        
        return true
    }
}


extension TallySDKAddCardViewController: WKNavigationDelegate {
    
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.progressView.isHidden = true;
        })
    }
    
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        fired += 1
        if (fired > 1){
            fetchWebPaymentStatus()
        }
        
    }
    
    
  
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        dismissAllBottom()
        oneButtonAlert(message: error.localizedDescription, title: "Error")
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        dismissAllBottom()
        oneButtonAlert(message: error.localizedDescription, title: "Error")
    }
    
    
   /* private func handleRedirectURL(url: URL){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
            
        }
           
      
    }*/
}
