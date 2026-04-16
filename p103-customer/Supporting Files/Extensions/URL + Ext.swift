//
//  URL + Ext.swift
//  u92
//
//  Created by Developer on 4/16/19.
//  Copyright © 2019 Anastasia Zhdanova. All rights reserved.
//
// swiftlint:disable all


import Foundation

extension URL {
    
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
    
    func params() -> String {
        var code = ""
        if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            if let queryItems = components.queryItems {
                for item in queryItems {
                    code = item.name.replacingOccurrences(of: "code", with: "")
                }
            }
        }
        return code
    }
}
