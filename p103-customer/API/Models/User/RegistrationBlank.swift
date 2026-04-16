//
//  RegistrationBlank.swift
//  p103-customer
//
//  Created by Alex Lebedev on 29.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

struct RegistrationMainStruct: Decodable {
    
    var email: String
    var password: String
    var zipCode: String
    
    var firstName: String
    var lastName: String
    var phone: String
    var workPhone: String
    var address: String
    var billingAddress: String
    var city: String
    
    var state: String
    var homePosition: [String: Int]
    
    var lockboxDoorCode: String?
    var lockboxLocation: String?
    var homeAlarmSystem: String?
    var otherHomeAccessNotes: String?
    var mailBox: String?
    var otherRequestNotes: String?
    
    var isMailKeyProvided: Bool?
    var isTurnLight: Bool?
    var isSomeoneAtHome: Bool?
    var isWaterPlantsExists: Bool?
    
    var comment: String?
    var hearAboutUs: String?
    var garbage: [String]?
    
    enum ProfileKeys: String, CodingKey {
        case email = "email"
        case password = "password"
        case zipCode = "zipCode"
        
        case firstName = "name"
        case lastName = "surname"
        case phone = "phoneNumber"
        case workPhone = "workPhoneNumber"
        case address = "homeAddress"
        case billingAddress = "billingAddress"
        
        case city = "city"
        case state = "state"
        case homePosition = "homePosition"
        
        case lockboxDoorCode = "lockboxDoorCode"
        case lockboxLocation = "lockboxLocation"
        case homeAlarmSystem = "homeAlarmSystem"
        case otherHomeAccessNotes = "otherHomeAccessNotes"
        case mailBox = "mailbox"
        case otherRequestNotes = "otherRequestNotes"
        
        case isMailKeyProvided = "isMailKeyProvided"
        case isTurnLight = "isTurnLight"
        case isSomeoneAtHome = "isSomeoneWillBeAtHome"
        case isWaterPlantsExists = "isWaterPlantsExists"
        
        case comment = "comment"
        case hearAboutUs = "hearAboutUs"
        case garbage = "garbages"
    }
    
    init(email: String, password: String, zipCode: String, firstName: String, lastName: String, phone: String, workPhone: String, address: String, billingAddress: String, city: String, state: String, homePosition: [String: Int], lockboxDoorCode: String?, lockboxLocation: String?, homeAlarmSystem: String?, otherHomeAccessNotes: String?, mailBox: String?, otherRequestsNotes: String?, isMailKeyProvided: Bool?, isTurnLight: Bool?, isSomeoneAtHome: Bool?, isWaterPlantsExists: Bool?, comment: String?, hearAboutUs: String, garbage: [String]?) {
        self.email = email
        self.password = password
        self.zipCode = zipCode
        
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.workPhone = workPhone
        self.address = address
        self.billingAddress = billingAddress
        self.city = city
        self.state = state
        self.homePosition = homePosition
        
        self.lockboxDoorCode = lockboxDoorCode
        self.lockboxLocation = lockboxLocation
        self.homeAlarmSystem = homeAlarmSystem
        self.otherHomeAccessNotes = otherHomeAccessNotes
        self.mailBox = mailBox
        self.otherRequestNotes = otherRequestsNotes
        self.isMailKeyProvided = isMailKeyProvided
        self.isTurnLight = isTurnLight
        self.isSomeoneAtHome = isSomeoneAtHome
        self.isWaterPlantsExists = isWaterPlantsExists
        self.comment = comment
        self.hearAboutUs = hearAboutUs
        self.garbage = garbage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProfileKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        zipCode = try container.decode(String.self, forKey: .zipCode)
        
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        phone = try container.decode(String.self, forKey: .phone)
        workPhone = try container.decode(String.self, forKey: .workPhone)
        address = try container.decode(String.self, forKey: .address)
        billingAddress = try container.decode(String.self, forKey: .billingAddress)
        
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        
        lockboxDoorCode = try? container.decode(String.self, forKey: .lockboxDoorCode)
        lockboxLocation = try? container.decode(String.self, forKey: .lockboxLocation)
        homeAlarmSystem = try? container.decode(String.self, forKey: .homeAlarmSystem)
        
        homePosition = try container.decode([String: Int].self, forKey: .homePosition)        
        
        otherHomeAccessNotes = try? container.decode(String.self, forKey: .otherHomeAccessNotes)
        mailBox = try? container.decode(String.self, forKey: .mailBox)
        otherRequestNotes = try? container.decode(String.self, forKey: .otherRequestNotes)
        
        isMailKeyProvided = try? container.decode(Bool.self, forKey: .isMailKeyProvided)
        isTurnLight = try? container.decode(Bool.self, forKey: .isTurnLight)
        isSomeoneAtHome = try? container.decode(Bool.self, forKey: .isSomeoneAtHome)
        isWaterPlantsExists = try? container.decode(Bool.self, forKey: .isWaterPlantsExists)
        
        comment = try? container.decode(String.self, forKey: .comment)
        garbage = try? container.decode(Array.self, forKey: .garbage)
        hearAboutUs = try? container.decode(String.self, forKey: .hearAboutUs)
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["email"] = self.email
        parameters["password"] = self.password
        parameters["zipCode"] = self.zipCode
        parameters["name"] = self.firstName
        parameters["surname"] = self.lastName
        parameters["phoneNumber"] = self.phone
        parameters["workPhoneNumber"] = self.workPhone
        parameters["homeAddress"] = self.address
        parameters["billingAddress"] = self.billingAddress
        parameters["city"] = self.city
        parameters["state"] = self.state
        parameters["homePosition"] = self.homePosition
        parameters["lockboxDoorCode"] = self.lockboxDoorCode
        parameters["lockboxLocation"] = self.lockboxLocation
        parameters["homeAlarmSystem"] = self.homeAlarmSystem
        parameters["otherHomeAccessNotes"] = self.otherHomeAccessNotes
        parameters["mailbox"] = self.mailBox
        parameters["otherRequestNotes"] = self.otherRequestNotes
        parameters["isMailKeyProvided"] = self.isMailKeyProvided
        parameters["isTurnLight"] = self.isTurnLight
        parameters["isSomeoneWillBeAtHome"] = self.isSomeoneAtHome
        parameters["isWaterPlantsExists"] = self.isWaterPlantsExists
        parameters["comment"] = self.comment
        parameters["hearAboutUs"] = self.hearAboutUs
        parameters["garbage"] = self.garbage
        return parameters
    }
}


struct RegistrationBlank {
    
    var email: String
    
    var firstName: String
    var lastName: String
    var phone: String
    var workPhone: String
    var address: String
    var billingAddress: String
    var city: String
    var homePosition: [String: Any]
    
    var state: String
    var emergences: [Emergence]
    var lockboxDoorCode: String?
    var lockboxLocation: String?
    var homeAlarmSystem: String?
    var otherHomeAccessNotes: String?
    var mailBox: String?
    var otherRequestsNotes: String?
    
    var isMailKeyProvided: Bool?
    var isTurnLight: Bool?
    var isSomeoneAtHome: Bool?
    var isWaterPlantsExists: Bool?
    
    var comment: String?
    var garbage: [String]?
    
    init(email: String, firstName: String, lastName: String, phone: String, workPhone: String, address: String, billingAddress: String, city: String, state: String, emergences: [Emergence], homePosition: [String: Any], lockboxDoorCode: String?, lockboxLocation: String?, homeAlarmSystem: String?, otherHomeAccessNotes: String?, mailBox: String?, otherRequestsNotes: String?, isMailKeyProvided: Bool?, isTurnLight: Bool?, isSomeoneAtHome: Bool?, isWaterPlantsExists: Bool?, comment: String?, garbage: [String]?) {
        self.email = email 
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.workPhone = workPhone
        self.address = address
        self.billingAddress = billingAddress
        self.city = city
        self.state = state
        self.emergences = emergences
        self.homePosition = homePosition
        self.lockboxDoorCode = lockboxDoorCode
        self.lockboxLocation = lockboxLocation
        self.homeAlarmSystem = homeAlarmSystem
        self.otherHomeAccessNotes = otherHomeAccessNotes
        self.mailBox = mailBox
        self.otherRequestsNotes = otherRequestsNotes
        self.isMailKeyProvided = isMailKeyProvided
        self.isTurnLight = isTurnLight
        self.isSomeoneAtHome = isSomeoneAtHome
        self.isWaterPlantsExists = isWaterPlantsExists
        self.comment = comment
        self.garbage = garbage
    }
    
    func convertToAddInfoParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["name"] = self.firstName
        parameters["surname"] = self.lastName
        parameters["phoneNumber"] = self.phone
        parameters["workPhoneNumber"] = self.workPhone
        parameters["homeAddress"] = self.address
        parameters["billingAddress"] = self.billingAddress
        parameters["city"] = self.city
        parameters["state"] = self.state
        let em = emergences.map { $0.convertToParameters()}
        let home = emergences.map { $0.convertToParameters()}
        parameters["emergences"] = em
        parameters["homePosition"] = home
        parameters["lockboxDoorCode"] = self.lockboxDoorCode
        parameters["lockboxLocation"] = self.lockboxLocation
        parameters["homeAlarmSystem"] = self.homeAlarmSystem
        parameters["otherHomeAccessNotes"] = self.otherHomeAccessNotes
        parameters["mailBox"] = self.mailBox
        parameters["otherRequestsNotes"] = self.otherRequestsNotes
        parameters["isMailKeyProvided"] = self.isMailKeyProvided
        parameters["isTurnLight"] = self.isTurnLight
        parameters["isSomeoneAtHome"] = self.isSomeoneAtHome
        parameters["isWaterPlantsExists"] = self.isWaterPlantsExists
        parameters["comment"] = self.comment
        parameters["garbage"] = self.garbage
        return parameters
    }
    func convertToEditCustomerParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["email"] = self.email
        parameters["name"] = self.firstName
        parameters["surname"] = self.lastName
        parameters["phoneNumber"] = self.phone
        parameters["workPhoneNumber"] = self.workPhone
        parameters["homeAddress"] = self.address
        parameters["billingAddress"] = self.billingAddress
        parameters["city"] = self.city
        parameters["state"] = self.state
        let em = emergences.map { $0.convertToParameters()}
        parameters["homePosition"] = homePosition
        parameters["emergences"] = em
        parameters["lockboxDoorCode"] = self.lockboxDoorCode
        parameters["lockboxLocation"] = self.lockboxLocation
        parameters["homeAlarmSystem"] = self.homeAlarmSystem
        parameters["otherHomeAccessNotes"] = self.otherHomeAccessNotes
        parameters["mailbox"] = self.mailBox
        parameters["otherRequestsNotes"] = self.otherRequestsNotes
        parameters["isMailKeyProvided"] = self.isMailKeyProvided
        parameters["isTurnLight"] = self.isTurnLight
        parameters["isSomeoneAtHome"] = self.isSomeoneAtHome
        parameters["isWaterPlantsExists"] = self.isWaterPlantsExists
        parameters["comment"] = self.comment
        parameters["garbage"] = self.garbage
        return parameters
    }
}
