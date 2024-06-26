//
//  MerchantsTableViewCell.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 07/06/2024.
//

import UIKit
import MapKit

class MerchantsTableViewCell: UITableViewCell, MKMapViewDelegate {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var backgroundSuperView: UIView!
    @IBOutlet weak var background1SuperView: UIView!
    @IBOutlet weak var background2SuperView: UIView!
    @IBOutlet weak var background3SuperView: UIView!
    
    var clickedToExpand: ((Int) -> ())?
    var clickedToCollapse: ((Int) -> ())?
    var indexOfItem = -1

    override func awakeFromNib() {
        super.awakeFromNib()
        mapview.delegate = self
        background1SuperView.isHidden = false
        background2SuperView.isHidden = true
        background3SuperView.isHidden = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpView(model: AllMerchantsResponseDatum, index: Int, expanded: Bool, config: TallyConfig){
        indexOfItem = index
        expandButton.tintColor = config.accentColor
        backgroundSuperView.borderWidth(config: config, radius: 6)
        
        background1SuperView.backgroundColor = config.backgroundColor
        background2SuperView.backgroundColor = config.backgroundColor
        background3SuperView.backgroundColor = config.backgroundColor
        
        firstLabel.font = config.mediumFont
        firstLabel.textColor = config.textColor
        firstLabel.text = model.accountName
        
        secondLabel.font = config.mediumFont
        secondLabel.textColor = config.textColor
        secondLabel.text = model.ptsp
        
        thirdLabel.font = config.mediumFont
        thirdLabel.textColor = config.textColor
        thirdLabel.text = model.slipFooter
        
        if (expanded){
            background2SuperView.isHidden = false
        }else{
            background2SuperView.isHidden = true
        }
    }
    
    @IBAction func expandView(){
        if background2SuperView.isHidden{
            clickedToExpand?(indexOfItem)
        }else{
            clickedToCollapse?(indexOfItem)
        }
      
    }

}
extension MerchantsTableViewCell: ReusableView {}
extension MerchantsTableViewCell: NibLoadableView {}
