//
//  TallyValidatorViewController.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 25/06/2024.
//

import UIKit

class TallyValidatorViewController: UIViewController, ProgressDisplayableControllerProtocol {
    
    var progressIndicatorView: ProgressIndicatorView = ProgressIndicatorView()
    
    var param: TallyParam!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = param.backgroundColor
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = param.backgroundColor
    }
    
    private func fetchData(){
        showProgress(config: param.tallyConfig(token: "", merchantId: ""), message: "Processing")
      
        NetworkHandler.shared.validateKey(param: param, completion: {[weak self] result in
            guard let self else{
                self?.oneButtonAlert(message: "", title: "unknown error")
                return
            }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let config = self.param.tallyConfig(token: data.token, merchantId: data.mid)
                    config.openTallyController(controller: self)
                }
            case .failure(let failure):
                DispatchQueue.main.async {
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
                    self.twoButtonAlert(message: message, title: "Error", ok: {
                        _ in
                        self.dismiss(animated: true)
                    }, cancel: {
                        _ in
                        self.dismiss(animated: true)
                    })
                    
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
