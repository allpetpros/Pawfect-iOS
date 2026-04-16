//
//  SmallPet.swift
//  p103-customer
//
//  Created by Daria Pr on 24.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

struct SmallPetGet: Decodable {
    var imageUrl: String
    var name: String
    var speciesType: String
    var gender: String
    var breed: String?
    var medicalNotes: String?
    var veterinarian: Veterian?
    
    enum SmallPetGetKeys: String, CodingKey {
        case imageUrl = "imageUrl"
        case name = "name"
        case speciesType = "speciesType"
        case gender = "gender"
        case breed = "breed"
        case medicalNotes = "medicalNotes"
        case veterinarian = "veterinarian"
    }
}

struct Veterian: Codable {
    var id: String
    var name: String
    var phoneNumber: String
    
    enum VeterianKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case phoneNumber = "phoneNumber"
    }
    
    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: VeterianKeys.self)
        id = try containter.decode(String.self, forKey: .id)
        name = try containter.decode(String.self, forKey: .name)
        phoneNumber = try containter.decode(String.self, forKey: .phoneNumber)
    }
    
    init(id: String, name: String, phoneNumber: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
    }
}

struct SmallPet: Decodable {
    
    var name: String
    var speciesType: String
    var gender: String
    var breed: String
    var medicalNotes: String?
    var veterinarians: [[String: String]]?
    
    enum SmallPetKeys: String, CodingKey {
        case name = "name"
        case speciesType = "speciesType"
        case gender = "gender"
        case breed = "breed"
        case medicalNotes = "medicalNotes"
        case veterinarians = "veterinarians"
    }
    
    init(name: String, speciesType: String, gender: String, breed: String, medicalNotes: String?, veterinarians: [[String: String]]?) {
        self.name = name
        self.speciesType = speciesType
        self.gender = gender
        self.breed = breed
        self.medicalNotes = medicalNotes
        self.veterinarians = veterinarians
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SmallPetKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        speciesType = try container.decode(String.self, forKey: .speciesType)
        gender = try container.decode(String.self, forKey: .gender)
        breed = try container.decode(String.self, forKey: .breed)
        medicalNotes = try? container.decode(String.self, forKey: .medicalNotes)
        veterinarians = try? container.decode([[String: String]].self, forKey: .veterinarians)
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["name"] = self.name
        parameters["speciesType"] = self.speciesType
        parameters["gender"] = self.gender
        parameters["breed"] = self.breed
        parameters["medicalNotes"] = self.medicalNotes
        parameters["veterinarians"] = self.veterinarians
        return parameters
    }
}

struct SmallPetEdit: Decodable {
//    var imageUrl: String
    var image: String?
    var name: String
    var gender: String
    var breed: String
    var medicalNotes: String?
    var veterinarians: [[String: String]]?
    
    enum SmallPetKeys: String, CodingKey {
//        case imageUrl = "imageUrl"
        case name = "name"
        
        case gender = "gender"
        case breed = "breed"
        case medicalNotes = "medicalNotes"
        case veterinarians = "veterinarians"
    }
    
    init(name: String, gender: String, breed: String, medicalNotes: String?, veterinarians: [[String: String]]?) {
//        self.imageUrl = imageUrl
        self.name = name
        self.gender = gender
        self.breed = breed
        self.medicalNotes = medicalNotes
        self.veterinarians = veterinarians
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
//        parameters["imageUrl"] = self.imageUrl
        parameters["name"] = self.name
        parameters["gender"] = self.gender
        parameters["breed"] = self.breed
        parameters["medicalNotes"] = self.medicalNotes
        parameters["veterinarians"] = self.veterinarians
        return parameters
    }
}
