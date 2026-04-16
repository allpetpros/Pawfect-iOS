//
//  RegistrationFile.swift
//  p103-customer
//
//  Created by SOTSYS032 on 29/01/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import Foundation
struct RegistrationFile: Decodable {
    
    var email: String
    var password: String
    var zipCode: String
    var deviceToken: String
    var deviceType: Int
    
    
    enum RegistrationKeys: String, CodingKey {
        case email = "email"
        case password = "password"
        case zipCode = "zipCode"
        case deviceToken = "deviceToken"
        case deviceType = "deviceType"
    }  
    init(email: String, password: String, zipCode: String, deviceToken: String, deviceType: Int) {
        self.email = email
        self.password = password
        self.zipCode = zipCode
        self.deviceToken = deviceToken
        self.deviceType = deviceType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RegistrationKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        zipCode = try container.decode(String.self, forKey: .zipCode)
        deviceToken = try container.decode(String.self, forKey: .deviceToken)
        deviceType = try container.decode(Int.self, forKey: .deviceType)
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["email"] = self.email
        parameters["password"] = self.password
        parameters["zipCode"] = self.zipCode
        parameters["deviceToken"] = self.deviceToken
        parameters["deviceType"] = self.deviceType
        return parameters
    }
}


struct SignInRequest: Codable {
    
    var email: String
    var password: String
    var deviceToken: String
    var deviceType: Int
    
//
    enum SignInRequestKeys: String, CodingKey {
        case email = "email"
        case password = "password"
        case deviceToken = "deviceToken"
        case deviceType = "deviceType"
    }

    init(email: String, password: String, deviceToken: String, deviceType: Int) {
        self.email = email
        self.password = password
        self.deviceToken = deviceToken
        self.deviceType = deviceType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SignInRequestKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        deviceToken = try container.decode(String.self, forKey: .deviceToken)
        deviceType = try container.decode(Int.self, forKey: .deviceType)
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["email"] = self.email
        parameters["password"] = self.password
        parameters["deviceToken"] = self.deviceToken
        parameters["deviceType"] = self.deviceType
        print(parameters)
        return parameters
    }
}


