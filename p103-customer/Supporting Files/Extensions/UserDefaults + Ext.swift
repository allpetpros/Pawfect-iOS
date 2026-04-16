//
//  UserDefaults + Ext.swift
//  u92
//
//  Created by Developer on 4/12/19.
//  Copyright © 2019 Anastasia Zhdanova. All rights reserved.
//
// swiftlint:disable all


import Foundation

extension UserDefaults {
    
    // Add new cases for new UD values
    enum Keys: String {
        case authToken
    }
    
    // MARK: - Properties
    private var authToken: String? {
        get { return string(forUDKey: .authToken) }
        set { saveValue(newValue, forUDKey: .authToken) }
    }
    // MARK: - Public Methods
    func isValueSaved(_ UDkey: UserDefaults.Keys) -> Bool {
        return value(forKey: UDkey.rawValue) != nil
    }
    
    func removeValue(forUDKey key: UserDefaults.Keys) {
        removeObject(forKey: key.rawValue)
    }
    
    func removeAll() {
        if let bundleID = Bundle.main.bundleIdentifier {
            removePersistentDomain(forName: bundleID)
        }
    }
    
    // MARK: - User Info

    // MARK: - Helpers
    fileprivate func string(forUDKey key: UserDefaults.Keys) -> String? {
        return string(forKey: key.rawValue)
    }
    fileprivate func saveValue(_ value: Any?, forUDKey key: UserDefaults.Keys) {
        setValue(value, forKey: key.rawValue)
        synchronize()
    }
}
