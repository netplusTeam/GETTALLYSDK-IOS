//
//  TallySDKViewController.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 30/04/2024.
//

import UIKit

class TallySDKViewController: UIViewController, StoryboardLoadable {
    
    var config: TallyConfig!
    var encryptedModel: EncryptedQrModel?
    
    var goBackToApp: (() -> ())?
    
    @IBOutlet private weak var appBarView: UIView!
    
    @IBOutlet private weak var backButton: UIButton!
    
    @IBOutlet private weak var cardUnderlineView: UIView!
    @IBOutlet private weak var cardLabel: UILabel!
    @IBOutlet private weak var merchantUnderlineView: UIView!
    @IBOutlet private weak var merchantLabel: UILabel!
    @IBOutlet private weak var transactionUnderlineView: UIView!
    @IBOutlet private weak var transactionLabel: UILabel!
    @IBOutlet private weak var tokenCardUnderlineView: UIView!
    @IBOutlet private weak var tokenCardLabel: UILabel!
    
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var cardSubViewView: UIStackView!
    @IBOutlet private weak var cardSubUnderlineView: UIView!
    @IBOutlet private weak var cardSubLabel: UILabel!
    @IBOutlet private weak var cardSubRecentUnderlineView: UIView!
    @IBOutlet private weak var cardSubRecentLabel: UILabel!
    
    var homeState: TallyHomeState = .card
    var cardState: TallyCardState = .cardSubView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setSelected(label: cardLabel, underLine: cardUnderlineView)
        setUnSelected(labels: [transactionLabel, tokenCardLabel, merchantLabel], underLines: [transactionUnderlineView, tokenCardUnderlineView, merchantUnderlineView])
        
        setCardSelected(label: cardSubLabel, underLine: cardSubUnderlineView)
        setCardUnSelected(label: cardSubRecentLabel, underLine: cardSubRecentUnderlineView)
        
        self.view.backgroundColor = config.backgroundColor
        appBarView.backgroundColor = config.accentColor
        cardUnderlineView.backgroundColor = config.backgroundColor
        merchantUnderlineView.backgroundColor = config.accentColor
        transactionUnderlineView.backgroundColor = config.accentColor
        tokenCardUnderlineView.backgroundColor = config.accentColor
        cardSubViewView.isHidden = false
        
        backButton.tintColor = config.backgroundColor
        
        cardLabel.font = config.mediumFont
        transactionLabel.font = config.mediumFont
        tokenCardLabel.font = config.mediumFont
        merchantLabel.font = config.mediumFont
        cardSubLabel.font = config.mediumFont
        cardSubRecentLabel.font = config.mediumFont
        
        addChildController(addCardController)

        // Do any additional setup after loading the view.
    }
    
    private var addCardController: UIViewController {
        let controller = TallySDKAddCardViewController.fromStoryboard()
        controller.config = config
        controller.qrCodeGenerated = { [weak self] data in
            guard let data else {
                return
            }
            guard let self else {
                return
            }
            self.encryptedModel = data
            recentShown()
        }
        return controller
    }
    
    @IBAction func goBackHome(){
        print("we dismiss")
        goBackToApp?()
      //  self.dismiss(animated: true)
    }
    
    private var recentCardController: UIViewController {
        let controller = TallySDKRecentTokenizedViewController.fromStoryboard()
        controller.config = config
        controller.data = encryptedModel
        return controller
    }
    
    private var transactionController: UIViewController {
        let controller = TallySDKTransactionsViewController.fromStoryboard()
        controller.config = config
        return controller
    }
    
    private var tokenizedController: UIViewController {
        let controller = TalySDKTokenizedCardsViewController.fromStoryboard()
        controller.config = config
        return controller
    }
    
    private var merchantsController: UIViewController {
        let controller = MerchantsViewController.fromStoryboard()
        controller.config = config
        return controller
    }
    
    //
    

    
    
    @IBAction private func cardAction(){
        cardSubViewView.isHidden = false
        setSelected(label: cardLabel, underLine: cardUnderlineView)
        setUnSelected(labels: [transactionLabel, tokenCardLabel, merchantLabel], underLines: [transactionUnderlineView, tokenCardUnderlineView, merchantUnderlineView])
        if (homeState != .card){
            homeState = .card
            removeChildControllers()
            if (cardState == .cardSubView){
               addChildController(addCardController)
            }
            if (cardState == .recentSubview){
               addChildController(recentCardController)
            }
        }
    }
    

    
    @IBAction private func mercahntAction(){
        cardSubViewView.isHidden = true
        setSelected(label: merchantLabel, underLine: merchantUnderlineView)
        setUnSelected(labels: [transactionLabel, tokenCardLabel, cardLabel ], underLines: [transactionUnderlineView, tokenCardUnderlineView, cardUnderlineView ])
        if (homeState != .merchant){
            homeState = .merchant
            removeChildControllers()
            addChildController(merchantsController)
        }
    }
    
    @IBAction private func transactionAction(){
        cardSubViewView.isHidden = true
        setSelected(label: transactionLabel, underLine: transactionUnderlineView)
        setUnSelected(labels: [merchantLabel, tokenCardLabel, cardLabel ], underLines: [merchantUnderlineView, tokenCardUnderlineView, cardUnderlineView ])
        if (homeState != .transaction){
            homeState = .transaction
            removeChildControllers()
            addChildController(transactionController)
        }
    }
    
    @IBAction private func tokenCardAction(){
        cardSubViewView.isHidden = true
        setSelected(label: tokenCardLabel, underLine: tokenCardUnderlineView)
        setUnSelected(labels: [merchantLabel, transactionLabel, cardLabel ], underLines: [merchantUnderlineView, transactionUnderlineView, cardUnderlineView ])
        if (homeState != .token){
            homeState = .token
            removeChildControllers()
            addChildController(tokenizedController)
        }
    }
    
    
    @IBAction private func cardSubAction(){
        setCardSelected(label: cardSubLabel, underLine: cardSubUnderlineView)
        setCardUnSelected(label: cardSubRecentLabel, underLine: cardSubRecentUnderlineView)
        if (cardState != .cardSubView){
            cardState = .cardSubView
            removeChildControllers()
            addChildController(addCardController)
        }
    }
    
    @IBAction private func cardSubRecentAction(){
        recentShown()
    }
    
    private func recentShown() {
        setCardUnSelected(label: cardSubLabel, underLine: cardSubUnderlineView)
        setCardSelected(label: cardSubRecentLabel, underLine: cardSubRecentUnderlineView)
        if (cardState != .recentSubview){
            cardState = .recentSubview
            removeChildControllers()
            addChildController(recentCardController)
        }
    }
    
    private func setSelected(label: UILabel, underLine: UIView){
        label.textColor = config.backgroundColor
        underLine.backgroundColor = config.backgroundColor
    }
    
    private func setUnSelected(labels: [UILabel], underLines: [UIView]){
        for label in labels {
            label.textColor = config.textColor
        }
        for underLine in underLines {
            underLine.backgroundColor = config.accentColor
        }
      
    }
    
    private func setCardSelected(label: UILabel, underLine: UIView){
        label.textColor = config.accentColor
        underLine.backgroundColor = config.accentColor
    }
    
    private func setCardUnSelected(label: UILabel, underLine: UIView){
        label.textColor = config.textColor
        underLine.backgroundColor = config.backgroundColor
    }
    
    private func addChildController(_ child: UIViewController) {
        addChild(child)
        containerView.addSubview(child.view)
        child.view.frame = containerView.bounds
        child.didMove(toParent: self)
    }
    
    private func removeChildControllers() {
        for controller in self.children {
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
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


class TallySDKNavigationController: UINavigationController{
    
}
