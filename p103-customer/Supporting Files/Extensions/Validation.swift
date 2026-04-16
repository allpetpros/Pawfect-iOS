//
//  Validation.swift
//  p103-customer
//
//  Created by Yaroslav on 8/21/19.
//  Copyright © 2019 PULS Software. All rights reserved.
//
// swiftlint:disable all

import Foundation

func emailConform(to value: String)-> Bool {
    let regEmail = NSPredicate(format: "SELF MATCHES %@", "(?:[a-zA-Z0-9!#$%&'*+/=?^_{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$")
    return regEmail.evaluate(with: value)
}

func isValidEmail(_ email: String) -> Bool {
    //change from{2,64} to {2,3} at 12/01   
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func containsOnlyLetters(input: String) -> Bool {
   for chr in input {
      if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
         return false
      }
   }
   return true
}
//func conatinsLetterandSpaces(input:String) -> Bool{
//    let emailRegEx = "[a-zA-Z\s]+"
//
//    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//    return emailPred.evaluate(with: email)
//    
//}

func containsOnlyDigits(input: String) -> Bool {
    let numberRegex = "^[1-9][0-9]*$"
    let valid = NSPredicate(format: "SELF MATCHES %@", numberRegex).evaluate(with: input)
    return valid
}

func phoneValidation(phone: String) -> Bool {
    let phoneRegex = "^[0-9]{10}$"
    let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    return valid
}

func emergencyPhoneValidation(phone: String) -> Bool {
    let phoneRegex = "^[0-9]{9,14}$"
    let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    return valid
}

func lockBoxValidation(code: String) -> Bool {
//    let phoneRegex = "^[0-9]{2,27}+[#]{1}$"
    let phoneRegex = "^[0-9*#]{2,27}"
    let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: code)
    return valid
}

func isAddressShortValidation(address: String) -> Bool {
    let regex = "^[A-Z a-z]{2,27}\\s*"
    
    let valid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: address)
    return valid
}

func isAddressLongValidation(address: String) -> Bool {
    let regex = "^[A-Z a-z]{2,37}\\s*"
    
    let valid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: address)
    return valid
}

func mailBoxValidation(address: String) -> Bool {
    let regex = "^[A-Za-z0-9,.]{2,37}"
    
    let valid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: address)
    return valid
}

func homeAddressValidation(address: String) -> Bool {
    let regex = "^[A-Z a-z 0-9 , .]{3,37}\\s*"
    
    let valid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: address)
    return valid
}
