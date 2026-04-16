//
//  Emergence.swift
//  p103-customer
//
//  Created by Alex Lebedev on 16.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation

struct Emergence: Codable {
    var id: String?
    var name: String
    var phoneNumber: String
    
     func archive() -> Data {
        var fw = self
        return Data(bytes: &fw, count: MemoryLayout<Emergence>.stride)
    }
    
    func convertToParameters() -> [String: Any] {
         var parameters: [String: Any] = [:]
               parameters["name"] = name
               parameters["phoneNumber"] = phoneNumber
               return parameters
    }
    func convertToDB() -> EmergenceDB {
        let emergence = EmergenceDB(emergence: self)
        return emergence
    }
    enum EmergenceKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case phoneNumber = "phoneNumber"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EmergenceKeys.self)
        name = try container.decode(String.self, forKey: .name)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        id = try container.decode(String.self, forKey: .id)
    }
    init(emergenceDB: EmergenceDB) {
        self.name = emergenceDB.name
        self.phoneNumber = emergenceDB.phoneNumber
    }
    init(name: String, phoneNumber: String) {
        self.name = name
        self.phoneNumber = phoneNumber
    }
}

struct HomePosition: Codable {
    var lat: Int
    var long: Int
 
    enum HomePositionsKeys: String, CodingKey {
        case lat = "lat"
        case long = "long"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HomePositionsKeys.self)
        lat = try container.decode(Int.self, forKey: .lat)
        long = try container.decode(Int.self, forKey: .long)
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["lat"] = lat
        parameters["long"] = long
        return parameters
    }
    
    init(lat: Int, long: Int) {
        self.lat = lat
        self.long = long
    }
}
