//
//  AcardTransactionViewController.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 27/05/2024.
//

import UIKit

class AcardTransactionViewController: UIViewController, StoryboardLoadable, ProgressDisplayableControllerProtocol {
    var progressIndicatorView: ProgressIndicatorView = ProgressIndicatorView()
    var config: TallyConfig!
    var data: [UpdatedTransactionResponseRow] = []
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var qrCode = ""
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = config.backgroundColor
        self.emptyLabel.textColor = config.textColor
        self.emptyLabel.font = config.mediumFont
        self.emptyView.backgroundColor = config.backgroundColor
        self.closeButton.tintColor = config.accentColor
        emptyView.isHidden = true
        tableView.isHidden = true
        setupTableView()
        registerReusables()
        fetData()

        // Do any additional setup after loading the view.
    }
    
    private func fetData(){
        showProgress(config: config, message: "Fetching Transactions....")
        NetworkHandler.shared.getTransactions(payload: .init(qr_code_ids: [qrCode]), config: config, completion: {[weak self] result in
            guard let self else { return  }
            switch result {
            case .success(let resp):
                DispatchQueue.main.async {[weak self] in
                    guard let self else { return  }
                    self.hideProgress()
                    self.data = resp.data.rows
                    if resp.data.rows.isEmpty{
                        self.tableView.isHidden = true
                        self.emptyView.isHidden = false
                    }else{
                        self.tableView.isHidden = false
                        self.emptyView.isHidden = true
                        self.tableView.reloadData()
                    }
                }
            
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
                    self?.tableView.isHidden = true
                    self?.emptyView.isHidden = false
                    self?.oneButtonAlert(message: message, title: "Error")
                }
            }
        })
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setupBasicTallyTableView(config: config)
    }
    
    private func registerReusables() {
        tableView.register(TransactionItemTableViewCell.self)
    }
    
    
    @IBAction func closeView(){
        self.dismiss(animated: true, completion: nil)
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

extension AcardTransactionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionItemTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let dt = data[indexPath.row];
        cell.setUpView(model: .init(labelI: dt.merchantName, labelII: dt.agentName, labelIII: dt.amount.formatPrice(), labelIV: dt.responseMessage, labelV: dt.rrn, labelVI: dt.dateCreated?.stringFromDate(), config: config))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
}

