//
//  ProgressIndicator.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 01/05/2024.
//

import Foundation
import UIKit

 protocol ProgressDisplayableControllerProtocol {
    var progressIndicatorView: ProgressIndicatorView { get set }
    
    func showProgress(_ indicatorColor: UIColor, config: TallyConfig, message: String)
    func hideProgress()
}

 extension ProgressDisplayableControllerProtocol where Self: UIViewController {
    func showProgress(_ indicatorColor: UIColor = .orange, config: TallyConfig, message: String) {
        self.progressIndicatorView.showOnController(self, config: config, message: message)
    }
    
    func hideProgress() {
        self.progressIndicatorView.hide(self)
    }
}

 class ProgressIndicatorView {
    private let backgroundView = UIView()
    private var cardView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.setCornerRadius(8)
        return v
    }()
    private let activityIndicator = UIActivityIndicatorView()
    private var messageLabel: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textAlignment = .center
        txt.numberOfLines = 0
        return txt
    }()
    
    public init() {}
    
    public func showOnController(_ controller: UIViewController, config: TallyConfig, message: String) {
        guard let view = controller.view else { return }
        view.isUserInteractionEnabled = false
        backgroundView.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(backgroundView)
        backgroundView.addSubview(cardView)
        cardView.addSubview(activityIndicator)
        cardView.addSubview(messageLabel)
        messageLabel.text = message
        messageLabel.textColor = config.accentColor
        messageLabel.font = config.mediumFont
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .medium
        activityIndicator.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        activityIndicator.color = config.accentColor
        backgroundView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        cardView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        cardView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cardView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        activityIndicator.anchor(top: cardView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        activityIndicator.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        messageLabel.anchor(top: nil, leading: nil, bottom: cardView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        messageLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        
    /*    view.addConstraints([
            view.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
            view.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor),
            view.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: CGFloat(55.0)),
            backgroundView.heightAnchor.constraint(equalToConstant: CGFloat(55.0))
            ])*/
        
        activityIndicator.startAnimating()
    }
    
    public func hide(_ controller: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            guard let view = controller.view else { return }
            view.isUserInteractionEnabled = true
            self?.activityIndicator.stopAnimating()
            self?.backgroundView.removeFromSuperview()
        }
      
    }
}

