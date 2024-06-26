//
//  TallySDKRecentTokenizedViewController.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 11/05/2024.
//

import UIKit

class TallySDKRecentTokenizedViewController: UIViewController, StoryboardLoadable, ProgressDisplayableControllerProtocol {
    
    var progressIndicatorView: ProgressIndicatorView = ProgressIndicatorView()
    var config: TallyConfig!
    var data: EncryptedQrModel?
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var savedQRImage: UIImageView!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = config.backgroundColor
        saveLabel.textColor = config.textColor
        saveLabel.font = config.semiBoldFont
        saveButton.backgroundColor = config.accentColor
        saveButton.setTitleColor(config.accentLabelColor, for: .normal)
        saveButton.titleLabel?.font = config.mediumFont
        saveButton.setCornerRadius(8)
        
        self.emptyLabel.textColor = config.textColor
        self.emptyLabel.font = config.mediumFont
        self.emptyView.backgroundColor = config.backgroundColor
        guard let data  else {
            emptyView.isHidden = false
            savedQRImage.isHidden = true
            saveLabel.isHidden = true
            saveButton.isHidden = true
            return
        }
        emptyView.isHidden = true
        savedQRImage.isHidden = false
        saveLabel.isHidden = false
        saveButton.isHidden = false
        savedQRImage.image = data.image?.convertBase64StringToImage()
        saveLabel.text = data.issuingBank

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveButtonAction(){
        
        guard let selectedImage = savedQRImage.image else {
            return
        }

        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        if let error = error {
          
            oneButtonAlert(message: error.localizedDescription, title: "")
        } else {
            oneButtonAlert(message: "Image Saved Successfully to Photo Library", title: "")
        
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
