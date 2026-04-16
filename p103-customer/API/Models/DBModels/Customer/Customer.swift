//
//  Customer.swift
//  p103-customer
//
//  Created by Alex Lebedev on 31.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

struct CustomerShort: Codable {
    var name: String
    var surname: String
    var imageUrl: String?
    var balance: Double
    
    enum CustomerShortKeys: String, CodingKey {
        case name = "name"
        case surname = "surname"
        case imageUrl = "imageUrl"
        case balance = "balance"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomerShortKeys.self)
        name = try container.decode(String.self, forKey: .name)
        surname = try container.decode(String.self, forKey: .surname)
        imageUrl = try? container.decode(String.self, forKey: .imageUrl)
        balance = try container.decode(Double.self, forKey: .balance)
    }
}

struct CustomerStruct: Codable {
    
    var img: String?
    var email: String
    
    var firstName: String
    var lastName: String
    var phone: String
    var address: String
    var billingAddress: String
    var city: String
    var workPhoneNumber: String
    
    var state: String
    var zipCode: String
    
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
    var emergences: [[String: String]]?
    
    var comment: String?
    var garbage: [String]?
    
    enum CustomerKeys: String, CodingKey {
        case img = "imageUrl"
        case email = "email"
        
        case firstName = "name"
        case lastName = "surname"
        case phone = "phoneNumber"
        case address = "address"
        case billingAddress = "billingAddress"
        case workPhoneNumber = "workPhoneNumber"
        
        case city = "city"
        case state = "state"
        case zipCode = "zipCode"
        
        case lockboxDoorCode = "lockboxDoorCode"
        case lockboxLocation = "lockboxLocation"
        case homeAlarmSystem = "homeAlarmSystem"
        case otherHomeAccessNotes = "otherHomeAccessNotes"
        case mailBox = "mailbox"
        case otherRequestsNotes = "otherRequests"
        
        case isMailKeyProvided = "isMailKeyProvided"
        case isTurnLight = "isTurnLight"
        case isSomeoneAtHome = "isSomeoneWillBeAtHome"
        case isWaterPlantsExists = "isWaterPlantsExists"
        
        case emergences = "emergencies"
        
        case comment = "comment"
        case garbage = "garbages"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomerKeys.self)
        img = try? container.decode(String.self, forKey: .img)
        email = try container.decode(String.self, forKey: .email)
        
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        phone = try container.decode(String.self, forKey: .phone)
        address = try container.decode(String.self, forKey: .address)
        billingAddress = try container.decode(String.self, forKey: .billingAddress)
        
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        zipCode = try container.decode(String.self, forKey: .zipCode)
        
        lockboxDoorCode = try? container.decode(String.self, forKey: .lockboxDoorCode)
        lockboxLocation = try? container.decode(String.self, forKey: .lockboxLocation)
        homeAlarmSystem = try? container.decode(String.self, forKey: .homeAlarmSystem)
        
        otherHomeAccessNotes = try? container.decode(String.self, forKey: .otherHomeAccessNotes)
        mailBox = try? container.decode(String.self, forKey: .mailBox)
        otherRequestsNotes = try? container.decode(String.self, forKey: .otherRequestsNotes)
        
        isMailKeyProvided = try? container.decode(Bool.self, forKey: .isMailKeyProvided)
        isTurnLight = try? container.decode(Bool.self, forKey: .isTurnLight)
        isSomeoneAtHome = try? container.decode(Bool.self, forKey: .isSomeoneAtHome)
        isWaterPlantsExists = try? container.decode(Bool.self, forKey: .isWaterPlantsExists)
        
        comment = try? container.decode(String.self, forKey: .comment)
        garbage = try? container.decode(Array.self, forKey: .garbage)
        emergences = try? container.decode([[String: String]].self, forKey: .emergences)
        workPhoneNumber = try container.decode(String.self, forKey: .workPhoneNumber)
    }
    
}

struct Customer: Codable {
    
    var img: String?
    var email: String
    
    var firstName: String
    var lastName: String
    var phone: String
    var address: String
    var billingAddress: String
    var city: String
    
    var state: String
    var zipCode: Int
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
    var garbage: Garbage?
    
    enum CustomerKeys: String, CodingKey {
        case img = "avatarUrl"
        case email = "email"
        
        case firstName = "name"
        case lastName = "surname"
        case phone = "phoneNumber"
        case address = "homeAddress"
        case billingAddress = "billingAddress"
        
        case city = "city"
        case state = "state"
        case zipCode = "zipCode"
        case emergences = "emergences"
        
        case lockboxDoorCode = "lockboxDoorCode"
        case lockboxLocation = "lockboxLocation"
        case homeAlarmSystem = "homeAlarmSystem"
        case otherHomeAccessNotes = "otherHomeAccessNotes"
        case mailBox = "mailbox"
        case otherRequestsNotes = "otherRequestsNotes"
        
        case isMailKeyProvided = "isMailKeyProvided"
        case isTurnLight = "isTurnLight"
        case isSomeoneAtHome = "isSomeoneAtHome"
        case isWaterPlantsExists = "isWaterPlantsExists"
        
        case comment = "comment"
        case garbage = "garbage"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomerKeys.self)
        img = try? container.decode(String.self, forKey: .img)
        email = try container.decode(String.self, forKey: .email)
        
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        phone = try container.decode(String.self, forKey: .phone)
        address = try container.decode(String.self, forKey: .address)
        billingAddress = try container.decode(String.self, forKey: .billingAddress)
        
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        zipCode = try container.decode(Int.self, forKey: .zipCode) 
        emergences = try container.decode([Emergence].self, forKey: .emergences)
        
        lockboxDoorCode = try? container.decode(String.self, forKey: .lockboxDoorCode)
        lockboxLocation = try? container.decode(String.self, forKey: .lockboxLocation)
        homeAlarmSystem = try? container.decode(String.self, forKey: .homeAlarmSystem)
        
        otherHomeAccessNotes = try? container.decode(String.self, forKey: .otherHomeAccessNotes)
        mailBox = try? container.decode(String.self, forKey: .mailBox)
        otherRequestsNotes = try? container.decode(String.self, forKey: .otherRequestsNotes)
        
        isMailKeyProvided = try? container.decode(Bool.self, forKey: .isMailKeyProvided)
        isTurnLight = try? container.decode(Bool.self, forKey: .isTurnLight)
        isSomeoneAtHome = try? container.decode(Bool.self, forKey: .isSomeoneAtHome)
        isWaterPlantsExists = try? container.decode(Bool.self, forKey: .isWaterPlantsExists)
        
        comment = try? container.decode(String.self, forKey: .comment)
        garbage = try? container.decode(Garbage.self, forKey: .garbage)
    }
    
    func convertGarbageToDB() -> GarbageDB? {
        guard let garbage = self.garbage else { return nil}
        let garbageDB = GarbageDB()
        garbageDB.toMonday = garbage.toMonday
        garbageDB.toTuesday = garbage.toTuesday
        garbageDB.toWednesday = garbage.toTuesday
        garbageDB.toThursday = garbage.toThursday
        garbageDB.toFriday = garbage.toFriday
        garbageDB.toSaturday = garbage.toFriday
        garbageDB.toSunday = garbage.toSunday
        return garbageDB
    }
    init(customerDB: CustomerDB) {
        self.img = customerDB.img
        self.email = customerDB.email
        self.firstName = customerDB.firstName
        self.lastName = customerDB.lastName
        self.phone = customerDB.phone
        self.address = customerDB.address
        self.billingAddress = customerDB.billingAddress
        self.city = customerDB.city
        self.state = customerDB.state
        self.zipCode = customerDB.zipCode
        self.emergences = customerDB.emergences.map{ $0.convertToEmergenceLocal() }
        self.lockboxDoorCode = customerDB.lockboxDoorCode
        self.lockboxLocation = customerDB.lockboxLocation
        self.homeAlarmSystem = customerDB.homeAlarmSystem
        self.otherHomeAccessNotes = customerDB.otherHomeAccessNotes
        self.mailBox = customerDB.mailBox
        self.otherRequestsNotes = customerDB.otherRequestsNotes
        
        switch customerDB.isMailKeyProvided {
        case 1:
            self.isMailKeyProvided = true
        case 2:
            self.isMailKeyProvided = true
        default:
            self.isMailKeyProvided = nil
        }
        
        switch customerDB.isTurnLight {
        case 1:
            self.isTurnLight = true
        case 2:
            self.isTurnLight = true
        default:
            self.isTurnLight = nil
        }
        switch customerDB.isSomeoneAtHome {
        case 1:
            self.isSomeoneAtHome = true
        case 2:
            self.isSomeoneAtHome = true
        default:
            self.isSomeoneAtHome = nil
        }
        switch customerDB.isWaterPlantsExists {
        case 1:
            self.isWaterPlantsExists = true
        case 2:
            self.isWaterPlantsExists = true
        default:
            self.isWaterPlantsExists = nil
        }
        
        self.comment = customerDB.comment
        self.garbage = customerDB.garbage?.convertToLocal()
    }
}
