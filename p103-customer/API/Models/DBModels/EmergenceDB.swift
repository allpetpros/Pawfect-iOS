//
//  Emergence.swift
//  p103-customer
//
//  Created by Alex Lebedev on 16.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import RealmSwift

class EmergenceDB: Object {
     @objc dynamic var name: String = ""
     @objc dynamic var phoneNumber: String = ""
    
   convenience init(emergence: Emergence) {
    self.init()
        self.name = emergence.name
        self.phoneNumber = emergence.phoneNumber
    }
    
    func convertToEmergenceLocal() -> Emergence {
        let emergence = Emergence(emergenceDB: self)
        return emergence
    }
}
