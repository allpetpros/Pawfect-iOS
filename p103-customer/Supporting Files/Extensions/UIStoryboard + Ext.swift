//
//  UIStoryboard + Ext.swift
//  IQ Taxi Passenger
//
//  Created by Developer on 11/30/18.
//  Copyright © 2018 IQ Taxi. All rights reserved.
//
// swiftlint:disable all


import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    
    /// Add the new case for a new storyboard file
    /// new case = storyboard file name (storyboard name "Auth" -> case - "auth")
    
    enum Storyboard: String {
        case home
        case authorization
        case messages
        case menu
        case account
        case store
        case item
        
        var filename: String { return rawValue.firstCapitalized }
    }
    
    // MARK: - Convenience Initializers
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    // MARK: - Class Functions
    
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
    // MARK: - View Controller Instantiation from Generics
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(String(describing: T.self)) ")
        }
        
        return viewController
    }
}
