//
//  String + Ext.swift
//  u92
//
//  Created by Developer on 4/10/19.
//  Copyright © 2019 Anastasia Zhdanova. All rights reserved.
//
// swiftlint:disable all


import UIKit

extension String {
    
    var integer: Int {
        return Int(self) ?? 0
    }
    
    var secondFromString : Int{
        let components: Array = self.components(separatedBy: ":")
        let hours = components[0].integer
        let minutes = components[1].integer
        
        return Int((hours * 60 * 60) + (minutes * 60))
    }
    
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func deletingPrefix(_ prefix: String?) -> String {
        guard let prefix = prefix, hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
    func deletingSuffix(_ suffix: String?) -> String {
        guard let suffix = suffix, hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }
        
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil){
                if self.count>=4 && self.count<=27 {
                    return true
                }else{
                    return false
                }
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var isValidZip: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        if Set(self).isSubset(of: nums) {
            if self.count >= 5 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validation(name: String) -> Bool {
        let emailRegEx = "[A-Za-z ]+"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: name)
    }
    
    var isValidName: Bool {
        validation(name: self) ? true : false
    }
    
    var isValidPhone: Bool {
        phoneValidation(phone: self) ? true : false
    }
    
    var isEmergencyValidPhone: Bool {
       emergencyPhoneValidation(phone: self) ? true : false
    }
    
    var isLockBoxDoor: Bool {
        lockBoxValidation(code: self) ? true : false
    }
    
    var isAddressValid: Bool {
        isAddressShortValidation(address: self) ? true : false
    }
    
    var isNotesValid: Bool {
        isAddressLongValidation(address: self) ? true : false
    }
    
    var isMailBoxValid: Bool {
        mailBoxValidation(address: self) ? true : false
    }
    
    var isHomeAddressValid: Bool {
        homeAddressValidation(address: self) ? true : false
    }
}
