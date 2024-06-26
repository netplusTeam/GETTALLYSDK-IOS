//
//  MerchantsViewController.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 06/06/2024.
//

import UIKit

class MerchantsViewController: UIViewController, StoryboardLoadable, ProgressDisplayableControllerProtocol {
    
    var progressIndicatorView: ProgressIndicatorView = ProgressIndicatorView()

    var config: TallyConfig!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var data: [AllMerchantsResponseDatum] = []
    
    
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
        tableView.register(MerchantsTableViewCell.self)
    }
    
    
    private func fetchData(){
        showProgress(config: config, message: "Fetching Merchants....")
        NetworkHandler.shared.fetchAllMerchants(config: config, completion: {[weak self] result in
            guard let self else { return  }
            switch result {
            case .success(let resp):
                DispatchQueue.main.async {[weak self] in
                    guard let self else { return  }
                    self.hideProgress()
             
                    self.data = resp
                    if resp.isEmpty{
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MerchantsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MerchantsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let dt = data[indexPath.row];
        cell.setUpView(model: dt, index: indexPath.row, expanded: indexPath.row == indexExpanded, config: config)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == indexExpanded{
            return 352
        }
        
        return 112
    }
    
}

