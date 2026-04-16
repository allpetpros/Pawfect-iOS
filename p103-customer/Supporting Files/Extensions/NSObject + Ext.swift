//
//  NSObject + Ext.swift
//  u92
//
//  Created by Developer on 4/12/19.
//  Copyright © 2019 Anastasia Zhdanova. All rights reserved.
//
// swiftlint:disable all


import Foundation

protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

extension NameDescribable {
    
    var typeName: String {
        return String(describing: type(of: self))
    }
    
    static var typeName: String {
        return String(describing: self)
    }
}

extension NSObject: NameDescribable {
    static var className: String {
           return String(describing: self)
       }
}


