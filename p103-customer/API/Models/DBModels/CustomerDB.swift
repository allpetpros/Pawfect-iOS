//
//  Customer.swift
//  p103-customer
//
//  Created by Alex Lebedev on 31.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import RealmSwift

class CustomerDB: Object {
    @objc dynamic var img: String? = nil
    @objc dynamic var email: String = ""
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var billingAddress: String = ""
    @objc dynamic var city: String = ""
    
    @objc dynamic var state: String = ""
    @objc dynamic var zipCode: Int = 0
    var emergences = List<EmergenceDB>()
    
    @objc dynamic var lockboxDoorCode: String? = nil
    @objc dynamic var lockboxLocation: String? = nil
    @objc dynamic var homeAlarmSystem: String? = nil
    @objc dynamic var otherHomeAccessNotes: String? = nil
    @objc dynamic var mailBox: String? = nil
    @objc dynamic var otherRequestsNotes: String? = nil

    @objc dynamic var isMailKeyProvided: Int = 0
    @objc dynamic var isTurnLight: Int = 0
    @objc dynamic var isSomeoneAtHome: Int = 0
    @objc dynamic var isWaterPlantsExists: Int = 0
    
    
    @objc dynamic var comment: String? = nil
    @objc dynamic var garbage: GarbageDB? = nil
    
   convenience init(customer: Customer) {
    self.init()
        self.img = customer.img
        self.email = customer.email
        
        self.firstName = customer.firstName
        self.lastName = customer.lastName
        self.phone = customer.phone
        self.address = customer.address
        self.billingAddress = customer.billingAddress
        self.city = customer.city
        self.state = customer.state
        self.zipCode = customer.zipCode
        let emergence = customer.emergences.map{$0.convertToDB()}
        self.emergences.append(objectsIn: emergence)
        self.lockboxDoorCode = customer.lockboxDoorCode
        self.lockboxLocation = customer.lockboxLocation
        self.homeAlarmSystem = customer.homeAlarmSystem
        self.otherHomeAccessNotes = customer.otherHomeAccessNotes
        self.mailBox = customer.mailBox
        self.otherRequestsNotes = customer.otherRequestsNotes
    
    if let isTurnLight = customer.isTurnLight {
        self.isTurnLight = isTurnLight ? 1 : 2
    } else {
        self.isTurnLight = 0
    }
    if let isMailKeyProvided = customer.isMailKeyProvided {
         self.isMailKeyProvided = isMailKeyProvided ? 1 : 2
     } else {
         self.isMailKeyProvided = 0
     }
    if let isSomeoneAtHome = customer.isSomeoneAtHome {
           self.isSomeoneAtHome = isSomeoneAtHome ? 1 : 2
       } else {
           self.isSomeoneAtHome = 0
       }
    if let isWaterPlantsExists = customer.isWaterPlantsExists {
           self.isWaterPlantsExists = isWaterPlantsExists ? 1 : 2
       } else {
           self.isWaterPlantsExists = 0
       }
        self.comment = customer.comment
        self.garbage = customer.convertGarbageToDB()
    }

}
