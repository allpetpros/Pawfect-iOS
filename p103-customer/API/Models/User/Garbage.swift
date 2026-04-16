//
//  Garbage.swift
//  p103-customer
//
//  Created by Alex Lebedev on 29.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation

struct Garbage: Codable {
    
    var toMonday: Bool
    var toTuesday: Bool
    var toWednesday: Bool
    var toThursday: Bool
    var toFriday: Bool
    var toSaturday: Bool
    var toSunday: Bool
    
    enum GarbageKeys: String, CodingKey {
        case toMonday = "toMonday"
        case toTuesday = "toTuesday"
        case toWednesday = "toWednesday"
        case toThursday = "toThursday"
        case toFriday = "toFriday"
        case toSaturday = "toSaturday"
        case toSunday = "toSunday"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GarbageKeys.self)
        toMonday = try container.decode(Bool.self, forKey: .toMonday)
        toTuesday = try container.decode(Bool.self, forKey: .toTuesday)
        toWednesday = try container.decode(Bool.self, forKey: .toWednesday)
        toThursday = try container.decode(Bool.self, forKey: .toThursday)
        toFriday = try container.decode(Bool.self, forKey: .toFriday)
        toSaturday = try container.decode(Bool.self, forKey: .toSaturday)
        toSunday = try container.decode(Bool.self, forKey: .toSunday)
    }
    init(toMonday: Bool, toTuesday: Bool, toWednesday: Bool, toThursday: Bool, toFriday: Bool, toSaturday: Bool, toSunday: Bool) {
        self.toMonday = toMonday
        self.toTuesday = toTuesday
        self.toWednesday = toWednesday
        self.toThursday = toThursday
        self.toFriday = toFriday
        self.toSaturday = toSaturday
        self.toSunday = toSunday
    }
    init() {
        self.toMonday = false
        self.toTuesday = false
        self.toWednesday = false
        self.toThursday = false
        self.toFriday = false
        self.toSaturday = false
        self.toSunday = false
    }
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["toMonday"] = toMonday
        parameters["toTuesday"] = toTuesday
        parameters["toWednesday"] = toWednesday
        parameters["toThursday"] = toThursday
        parameters["toFriday"] = toFriday
        parameters["toSaturday"] = toSaturday
        parameters["toSunday"] = toSunday
        return parameters
    }
}
