//
//  TokenizedItemTableViewCell.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 12/05/2024.
//

import UIKit

class TokenizedItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bankLabel: UILabel!
    
    @IBOutlet weak var bankLargeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var qrImageLarge: UIImageView!
    @IBOutlet weak var expandButtton: UIButton!
    @IBOutlet weak var collapseButtton: UIButton!
    @IBOutlet weak var downloadButtton: UIButton!
    @IBOutlet weak var viewButtton: UIButton!
    @IBOutlet weak var backgroundSuperView: UIView!
    @IBOutlet weak var backgroundSuperView2: UIView!
    var clickedToExpand: ((Int) -> ())?
    var clickedToCollapse: ((Int) -> ())?
    var clickedToView: (() -> ())?
    var clickedToSave: ((String) -> ())?
    var indexOfItem = -1

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundSuperView.isHidden = false
        backgroundSuperView2.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpView(model: TokenizedItemModel, index: Int, expanded: Bool){
        
        indexOfItem = index
        
        
        backgroundSuperView.backgroundColor = model.config.backgroundColor
        backgroundSuperView.borderWidth(config: model.config, radius: 8.0)
        
        backgroundSuperView2.backgroundColor = model.config.backgroundColor
        backgroundSuperView2.borderWidth(config: model.config, radius: 8.0)
        
        if (expanded){
            backgroundSuperView.isHidden = true
            backgroundSuperView2.isHidden = false
        }else{
            backgroundSuperView.isHidden = false
            backgroundSuperView2.isHidden = true
        }
        
        downloadButtton.tintColor = model.config.accentColor
        collapseButtton.tintColor = model.config.accentColor
        expandButtton.tintColor = model.config.accentColor
        
        viewButtton.backgroundColor = model.config.accentColor
        viewButtton.setTitleColor(model.config.backgroundColor, for: .normal)
        viewButtton.titleLabel?.font = model.config.semiBoldFont
        viewButtton.setCornerRadius(8)
        
        bankLabel.font = model.config.mediumFont
        bankLabel.textColor = model.config.textColor
        bankLabel.text = model.data.issuingBank
        
        bankLargeLabel.font = model.config.mediumFont
        bankLargeLabel.textColor = model.config.textColor
        bankLargeLabel.text = model.data.issuingBank
        
        dateLabel.font = model.config.mediumFont
        dateLabel.textColor = model.config.textColor
        dateLabel.text = model.data.issuingBank
        
        qrImage.image = model.data.image?.convertBase64StringToImage()
        qrImageLarge.image = model.data.image?.convertBase64StringToImage()
        
        bankLabel.text = model.data.issuingBank
        bankLargeLabel.text = "\(model.data.issuingBank ?? "") \(model.data.cardScheme ?? "")"
        dateLabel.text = model.data.date
    }
    
    @IBAction func expandView(){
        clickedToExpand?(indexOfItem)
    }
    
    @IBAction func compressView(){
        clickedToCollapse?(indexOfItem)
    }
    
    @IBAction func openView(){
        clickedToView?()
    }
    
    @IBAction func saveImage() {

        guard let selectedImage = qrImageLarge.image else {
            return
        }

        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    //MARK: - Save Image callback

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        if let error = error {
           
            clickedToSave?(error.localizedDescription)
        } else {
            clickedToSave?("Image Saved Successfully to Photo Library")
      
        }
    }
    
}


extension TokenizedItemTableViewCell: ReusableView {}
extension TokenizedItemTableViewCell: NibLoadableView {}


public struct TokenizedItemModel {
    let data: EncryptedQrModel
    let config: TallyConfig
}
