//
//  TransactionItemTableViewCell.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 07/05/2024.
//

import UIKit

class TransactionItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var sixthLabel: UILabel!
    @IBOutlet weak var backgroundSuperView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstLabel.isHidden = true
        secondLabel.isHidden = true
        thirdLabel.isHidden = true
        fourthLabel.isHidden = true
        fifthLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    func setUpView(model: TransactionItemModel){
        backgroundSuperView.backgroundColor = model.config.backgroundColor
        backgroundSuperView.borderWidth(config: model.config, radius: 8.0)
        if let labelI =  model.labelI {
            firstLabel.isHidden = false
            firstLabel.text = labelI
            firstLabel.textColor = model.config.textColor
        }
        if let labelII =  model.labelII {
            secondLabel.isHidden = false
            secondLabel.text = labelII
            secondLabel.textColor = model.config.textColor
        }
        if let labelIII =  model.labelIII {
            thirdLabel.isHidden = false
            thirdLabel.text = labelIII
            thirdLabel.textColor = model.config.textColor
        }
        if let labelIV =  model.labelIV {
            fourthLabel.isHidden = false
            fourthLabel.text = labelIV
            fourthLabel.textColor = model.config.textColor
        }
        if let labelV =  model.labelV {
            fifthLabel.isHidden = false
            fifthLabel.text = labelV
            fifthLabel.textColor = model.config.textColor
        }
        if let labelVI =  model.labelVI {
            sixthLabel.isHidden = false
            sixthLabel.text = labelVI
            sixthLabel.textColor = model.config.textColor
        }
        
    }
    
}


extension TransactionItemTableViewCell: ReusableView {}
extension TransactionItemTableViewCell: NibLoadableView {}

public struct TransactionItemModel {
    let labelI: String?
    let labelII: String?
    let labelIII: String?
    let labelIV: String?
    let labelV: String?
    let labelVI: String?
    let config: TallyConfig
}
