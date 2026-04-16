//
//  EmployeeDB.swift
//  p103-customer
//
//  Created by Alex Lebedev on 13.08.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import RealmSwift

class EmployeeDB: Object {
    @objc dynamic var email: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var homeAddress: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var workFromInMS: Int = 0
    @objc dynamic var workToInMS: Int = 0
    var emergences = List<EmergenceDB>()
    
    convenience init(employee: Employee) {
        self.init()
        self.email = employee.email
        self.name = employee.name
        self.surname = employee.surname
        self.homeAddress = employee.homeAddress
        self.phoneNumber = employee.phoneNumber
        self.workFromInMS = employee.workFromInMS
        self.workToInMS = employee.workToInMS
        
        let emergence = employee.emergences.map{$0.convertToDB()}
        self.emergences.append(objectsIn: emergence)
    }
}
