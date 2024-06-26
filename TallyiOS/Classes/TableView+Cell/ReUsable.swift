//
//  ReUsable.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 07/05/2024.
//

import Foundation

import Foundation
import UIKit

extension UIView {
     class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
     func addViews(_ subviews: [UIView]) {
        for view in subviews {
            self.addSubview(view)
        }
    }
}

 protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    
     static var defaultReuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

 protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    
    static func instanceFromNib() -> Self {
        return Bundle.init(for: Self.self).loadNibNamed(nibName, owner: nil, options: nil)!.first as! Self
    }
    
     static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

 extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView & NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    final func registerHeader<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) where T: ReusableView & NibLoadableView {
        register(UINib(nibName: headerFooterViewType.nibName, bundle: Bundle(for: T.self)), forHeaderFooterViewReuseIdentifier: headerFooterViewType.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func dequeueHeader<T: UITableViewHeaderFooterView>() -> T where T: ReusableView {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return header
    }
    
    func setupBasicTallyTableView(clearBackgroundColor: Bool? = false, config: TallyConfig) {
        tableFooterView = UIView()
        tableHeaderView = UIView()
        sectionHeaderHeight = 0.0
        sectionFooterHeight = 0.0
        rowHeight = UITableView.automaticDimension
        separatorStyle = .none
        switch clearBackgroundColor {
        case true:
            backgroundColor = .clear
        default:
            backgroundColor = config.backgroundColor
        }
        guard #available(iOS 15.0, *) else { return }
        sectionHeaderTopPadding = 0.0
    }
}
