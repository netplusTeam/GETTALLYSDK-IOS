//
//  TalySDKTokenizedCardsViewController.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 12/05/2024.
//

import UIKit

class TalySDKTokenizedCardsViewController: UIViewController, StoryboardLoadable {
    
    var config: TallyConfig!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var data: [EncryptedQrModel] = []
    
    var indexExpanded = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = config.backgroundColor
        self.emptyLabel.textColor = config.textColor
        self.emptyLabel.font = config.mediumFont
        self.emptyView.backgroundColor = config.backgroundColor
        emptyView.isHidden = true
        tableView.isHidden = true
        setupTableView()
        registerReusables()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = config.backgroundColor
        self.emptyLabel.textColor = config.textColor
        self.emptyLabel.font = config.mediumFont
        self.emptyView.backgroundColor = config.backgroundColor
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setupBasicTallyTableView(config: config)
    }
    
    private func registerReusables() {
        tableView.register(TokenizedItemTableViewCell.self)
    }
    
    
    private func fetchData(){
        guard let fetchedData = UserStore.shared.readEncryptedModel() else{
            emptyView.isHidden = false
            tableView.isHidden = true
            return
        }
        data = fetchedData.data
        if data.isEmpty{
            emptyView.isHidden = false
            tableView.isHidden = true
        }else{
            emptyView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
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
extension TalySDKTokenizedCardsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TokenizedItemTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let dt = data[indexPath.row]
        cell.setUpView(model: .init(data: .init(qrcodeId: dt.qrcodeId, image: dt.image, cardScheme: dt.cardScheme, issuingBank: dt.issuingBank, date: dt.date), config: config), index: indexPath.row, expanded: indexPath.row == indexExpanded)
        cell.clickedToExpand = {[weak self] int in
            guard let self else{
                return
            }
            self.indexExpanded = int
            self.tableView.reloadData()
        }
        
        cell.clickedToCollapse = {[weak self] int in
            guard let self else{
                return
            }
            self.indexExpanded = -1
            self.tableView.reloadData()
        }
        cell.clickedToSave = {[weak self] message in
            guard let self else{
                return
            }
            self.oneButtonAlert(message: message, title: "")
        }
        
        cell.clickedToView = {[weak self] in
            guard let self else{
                return
            }
            let vc = AcardTransactionViewController.fromStoryboard()
            vc.config = config
            vc.qrCode = dt.qrcodeId ?? ""
            vc.modalPresentationStyle  = .fullScreen
            self.present(vc, animated: true)
           // self.navigationController?.pushViewController(vc, animated: true)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == indexExpanded{
            return 296
        }
        
        return 80
    }
    
    
}
