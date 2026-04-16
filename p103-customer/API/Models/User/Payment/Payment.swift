//
//  Payment.swift
//  p103-customer
//
//  Created by SOTSYS032 on 02/02/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
struct GetCards: Codable {
    var items = [Item]()
    
}
struct Item : Codable {
    var id: String
    var fourDigits: String
    var token: String?
    var isChosen: Bool?
    
    enum CardsShortKeys: String, CodingKey {
        case id = "id"
        case fourDigits = "fourDigits"
        case token = "token"
        case isChosen = "isChosen"
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CardsShortKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        fourDigits = try container.decode(String.self, forKey: .fourDigits)
//        token = try? container.decode(String.self, forKey: .token)
//        isChosen = try? container.decode(Bool.self, forKey: .isChosen)
//    }
}
struct AddCard: Decodable {
    
    var number: String
//    var exp_month: Int
    var expiration: String
    var cvc: String
    
    enum AddCardKeys: String, CodingKey {
        case number = "number"
//        case exp_month = "exp_month"
        case expiration = "expiration"
        case cvc = "cvc"
    }
    
    init(number: String, expiration: String,cvc: String) {
        self.number = number
//        self.exp_month = exp_month
        self.expiration = expiration
        self.cvc = cvc
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AddCardKeys.self)
        
        number = try container.decode(String.self, forKey: .number)
//        exp_month = try container.decode(Int.self, forKey: .exp_month)
        expiration = try container.decode(String.self, forKey: .expiration)
        cvc = try container.decode(String.self, forKey: .cvc)
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["number"] = self.number
//        parameters["exp_month"] = self.exp_month
        parameters["expiration"] = self.expiration
        parameters["cvc"] = self.cvc
        return parameters
    }
}

struct AddAmount: Decodable {
    
    var total: Double
    var token: String

    enum AddAmountKeys: String, CodingKey {
        case total = "total"
        case token = "token"
       
    }
    
    init(total: Double, token: String) {
        self.total = total
        self.token = token
       
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AddAmountKeys.self)
        
        total = try container.decode(Double.self, forKey: .total)
        token = try container.decode(String.self, forKey: .token)
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["total"] = self.total
        parameters["token"] = self.token
        return parameters
    }
}

