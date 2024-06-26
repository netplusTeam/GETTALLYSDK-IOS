//
//  StoryboardLoadable.swift
//  TallyiOS
//
//  Created by Promise Ochornma on 30/04/2024.
//

import Foundation
import UIKit

public protocol StoryboardLoadable {}

public extension StoryboardLoadable where Self: UIViewController {
    static func className() -> String {
        return "\(self)".split(separator:".").map(String.init).last!
    }
    
    static func fromStoryboard(named name: String = Self.className(), with identifier: String = Self.className(), bundle: Bundle = Bundle(for: Self.self)) -> Self {
        let storyboard = UIStoryboard.init(name: name, bundle: bundle)
        
        guard let instance = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("ERROR: Unable to load storyboard for \"\(self)\"")
        }
        return instance
    }
}
