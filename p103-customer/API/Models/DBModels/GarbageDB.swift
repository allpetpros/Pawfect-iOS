//
//  Garbage.swift
//  p103-customer
//
//  Created by Alex Lebedev on 29.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import RealmSwift

class GarbageDB: Object {
    
    @objc dynamic var toMonday: Bool = false
    @objc dynamic var toTuesday: Bool = false
    @objc dynamic var toWednesday: Bool = false
    @objc dynamic var toThursday: Bool = false
    @objc dynamic var toFriday: Bool = false
    @objc dynamic var toSaturday: Bool = false
    @objc dynamic var toSunday: Bool = false
    
    func convertToLocal() -> Garbage {
        let garbage = Garbage(toMonday: self.toMonday, toTuesday: self.toTuesday, toWednesday: self.toWednesday, toThursday: self.toThursday, toFriday: self.toFriday, toSaturday: self.toSaturday, toSunday: self.toSunday)
        return garbage
    }
}
