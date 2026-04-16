//
//  AllPets.swift
//  p103-customer
//
//  Created by Alex Lebedev on 07.08.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation

struct DogStructGet: Codable {
    var name: String
    var speciesType: String
    var gender: String?
    var size: Int
    var sizeType: String
    var dob: Int?
    var age: Int?
    var breed: String?
    var feedingInstructions: String?
    var medicationInstructions: String?
    var isSprayed: Bool?
    var onWalks: [String]?
    var onSomeoneEntry: [String]?
    var hasMedication: Bool?
    var medicalRequirements: String?
    var medicalNotes: String?
    var isDoggyDoorExists: Bool?
    var veterinarian: Veterian?
    var character: String?
    
    enum DogStructGetCodingKeys: String, CodingKey {
        case name = "name"
        case speciesType = "speciesType"
        case gender = "gender"
        case breed = "breed"
        case dob = "dob"
        case age = "age"
        case size = "size"
        case sizeType = "sizeType"
        case feedingInstructions = "feedingInstructions"
        case medicationInstructions = "medicationInstructions"
        case isSprayed = "isSprayed"
        case onWalks = "onWalks"
        case onSomeoneEntry = "onSomeoneEntry"
        case hasMedication = "hasMedication"
        case medicalRequirements = "medicalRequirements"
        case medicalNotes = "medicalNotes"
        case isDoggyDoorExists = "isDoggyDoorExists"
        case veterinarians = "veterinarian"
        case character = "character"
    }
}

struct DogStructEdit: Codable {
    var name: String
    var gender: String
    var size: Int
    var sizeType: String
    var age: Int?
    var dob: Int?
    var breed: String?
    var feedingInstructions: String?
    var medicationInstructions: String?
    var isSpayed: Bool?
    var onWalksActions: [String]?
    var onSomeoneEntryActions: [String]?
    var hasMedication: Bool?
    var medicalRequirements: String?
    var medicalNotes: String?
    var isDoggyDoorExists: Bool?
    var veterinarians: [[String: String]]?
    var character: String?
    
    enum DogStructEditCodingKeys: String, CodingKey {
        case name = "name"
        case gender = "gender"
        case breed = "breed"
        case dob = "dob"
        case age = "age"
        case size = "size"
        case sizeType = "sizeType"
        case feedingInstructions = "feedingInstructions"
        case medicationInstructions = "medicationInstructions"
        case isSpayed = "isSpayed"
        case onWalksActions = "onWalksActions"
        case onSomeoneEntryActions = "onSomeoneEntryActions"
        case hasMedication = "hasMedication"
        case medicalRequirements = "medicalRequirements"
        case medicalNotes = "medicalNotes"
        case isDoggyDoorExists = "isDoggyDoorExists"
        case veterinarians = "veterinarians"
        case character = "character"
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["name"] = self.name
        parameters["gender"] = self.gender
        parameters["breed"] = self.breed
        parameters["size"] = self.size
        parameters["sizeType"] = self.sizeType
        parameters["medicalNotes"] = self.medicalNotes
        parameters["medicalRequirements"] = self.medicalRequirements
        parameters["veterinarians"] = self.veterinarians
        parameters["dob"] = self.dob
        parameters["age"] = self.age
        parameters["onWalksActions"] = self.onWalksActions
        parameters["onSomeoneEntryActions"] = self.onSomeoneEntryActions
        parameters["feedingInstructions"] = self.feedingInstructions
        parameters["medicationInstructions"] = self.medicationInstructions
        parameters["isSpayed"] = self.isSpayed
        parameters["isDoggyDoorExists"] = self.isDoggyDoorExists
        parameters["hasMedication"] = self.hasMedication
        parameters["character"] = self.character
        return parameters
    }
}

struct DogStruct: Codable {
    var name: String
    var speciesType: String
    var gender: String
    var size: Int?
    var sizeType: String?
    var dob: Int?
    var age: Int?
    var breed: String?
    var feedingInstructions: String?
    var medicationInstructions: String?
    var isSpayed: Bool?
    var onWalksActions: [String]?
    var onSomeoneEntryActions: [String]?
    var hasMedication: Bool?
    var medicalRequirements: String?
    var medicalNotes: String?
    var isDoggyDoorExists: Bool?
    var veterinarians: [[String: String]]?

//    var character: String?
    
    enum DogStructCodingKeys: String, CodingKey {
        case name = "name"
        case speciesType = "speciesType"
        case gender = "gender"
        case breed = "breed"
        case dob = "dob"
        case age = "age"
        case size = "size"
        case sizeType = "sizeType"
        case feedingInstructions = "feedingInstructions"
        case medicationInstructions = "medicationInstructions"
        case isSpayed = "isSpayed"
        case onWalksActions = "onWalksActions"
        case onSomeoneEntryActions = "onSomeoneEntryActions"
        case hasMedication = "hasMedication"
        case medicalRequirements = "medicalRequirements"
        case medicalNotes = "medicalNotes"
        case isDoggyDoorExists = "isDoggyDoorExists"
        case veterinarians = "veterinarians"
//        case character = "character"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DogStructCodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        gender = try container.decode(String.self, forKey: .gender)
        speciesType = try container.decode(String.self, forKey: .speciesType)
        breed = try? container.decode(String.self, forKey: .breed)
        size = try container.decode(Int.self, forKey: .size)
        sizeType = try container.decode(String.self, forKey: .sizeType)
        dob = try? container.decode(Int.self, forKey: .dob)
        age = try? container.decode(Int.self, forKey: .age)
        feedingInstructions = try? container.decode(String.self, forKey: .feedingInstructions)
        onWalksActions = try? container.decode([String].self, forKey: .onWalksActions)
        onSomeoneEntryActions = try? container.decode([String].self, forKey: .onSomeoneEntryActions)
        medicationInstructions = try? container.decode(String.self, forKey: .medicationInstructions)
        isSpayed = try? container.decode(Bool.self, forKey: .isSpayed)
        medicalNotes = try? container.decode(String.self, forKey: .medicalNotes)
        medicalRequirements = try? container.decode(String.self, forKey: .medicalRequirements)
        veterinarians = try? container.decode([[String: String]].self, forKey: .veterinarians)
        hasMedication = try? container.decode(Bool.self, forKey: .hasMedication)
        isDoggyDoorExists = try? container.decode(Bool.self, forKey: .isDoggyDoorExists)
//        character = try? container.decode(String.self, forKey: .character)
    }
    
    init(name: String, speciesType: String, gender: String, size: Int?, sizeType: String?, breed: String?, dob: Int?,age: Int?, feedingInstructions: String?, onWalksActions: [String]?, onSomeoneEntryActions: [String]?, medicationInstructions: String?, isSpayed: Bool?, medicalNotes: String?, medicalRequirements: String?, veterinarians: [[String: String]]?, hasMedication: Bool?, isDoggyDoorExists: Bool?) {
        self.name = name
        self.speciesType = speciesType
        self.gender = gender
        self.breed = breed
        self.size = size
        self.sizeType = sizeType
        self.dob = dob
        self.age = age
        self.feedingInstructions = feedingInstructions
        self.onWalksActions = onWalksActions
        self.onSomeoneEntryActions = onSomeoneEntryActions
        self.medicationInstructions = medicationInstructions
        self.isSpayed = isSpayed
        self.medicalNotes = medicalNotes
        self.medicalRequirements = medicalRequirements
        self.veterinarians = veterinarians
        self.hasMedication = hasMedication
        self.isDoggyDoorExists = isDoggyDoorExists
//        self.character = character
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["name"] = self.name
        parameters["speciesType"] = self.speciesType
        parameters["gender"] = self.gender
        parameters["breed"] = self.breed
        parameters["size"] = self.size
        parameters["sizeType"] = self.sizeType
        parameters["medicalNotes"] = self.medicalNotes
        parameters["medicalRequirements"] = self.medicalRequirements
        parameters["veterinarians"] = self.veterinarians
        parameters["dob"] = self.dob
        parameters["age"] = self.age
        parameters["onWalksActions"] = self.onWalksActions
        parameters["onSomeoneEntryActions"] = self.onSomeoneEntryActions
        parameters["feedingInstructions"] = self.feedingInstructions
        parameters["medicationInstructions"] = self.medicationInstructions
        parameters["isSpayed"] = self.isSpayed
        parameters["isDoggyDoorExists"] = self.isDoggyDoorExists
        parameters["hasMedication"] = self.hasMedication
//        parameters["character"] = self.character
        return parameters
    }
}

struct CatStructGet: Codable {
    var name: String
    var speciesType: String
    var gender: String
    var age: Int?
    var dob: Int?
    var breed: String?
    var medicalNotes: String?
    var medicalRequirements: String?
    var veterinarian: Veterian?
    var feedingInstructions: String?
    var medicationInstructions: String?
    var isSprayed: Bool?
    var hasMedication: Bool?
    var character: String?
    var locationOfLitterbox: String?
    
    enum CatStructCodingKeys: String, CodingKey {
        case name = "name"
        case speciesType = "speciesType"
        case gender = "gender"
        case breed = "breed"
        case medicalNotes = "medicalNotes"
        case medicalRequirements = "medicalRequirements"
        case veterinarian = "veterinarian"
        case dob = "dob"
        case age = "age"
        case feedingInstructions = "feedingInstructions"
        case medicationInstructions = "medicationInstructions"
        case isSprayed = "isSprayed"
        case hasMedication = "hasMedication"
        case character = "character"
        case locationOfLitterbox = "locationOfLitterbox"
    }
}

struct CatStructEdit: Codable {
    var name: String
    var speciesType: String
    var gender: String
    var age: Int?
    var dob: Int?
    var breed: String?
    var medicalNotes: String?
    var medicalRequirements: String?
    var veterinarian: [[String: String]]?
    var feedingInstructions: String?
    var medicationInstructions: String?
    var isSprayed: Bool?
    var hasMedication: Bool?
    var character: String?
    var locationOfLitterbox: String?
    
    enum CatStructCodingKeys: String, CodingKey {
        case name = "name"
        case speciesType = "speciesType"
        case gender = "gender"
        case breed = "breed"
        case medicalNotes = "medicalNotes"
        case medicalRequirements = "medicalRequirements"
        case veterinarian = "veterinarian"
        case age = "age"
        case dob = "dob"
        case feedingInstructions = "feedingInstructions"
        case medicationInstructions = "medicationInstructions"
        case isSprayed = "isSpayed"
        case hasMedication = "hasMedication"
        case character = "character"
        case locationOfLitterbox = "locationOfLitterbox"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CatStructCodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        gender = try container.decode(String.self, forKey: .gender)
        speciesType = try container.decode(String.self, forKey: .speciesType)
        medicalNotes = try? container.decode(String.self, forKey: .medicalNotes)
        medicalRequirements = try? container.decode(String.self, forKey: .medicalRequirements)
        veterinarian = try? container.decode([[String: String]].self, forKey: .veterinarian)
        age = try? container.decode(Int.self, forKey: .age)
        dob = try? container.decode(Int.self, forKey: .dob)
        feedingInstructions = try? container.decode(String.self, forKey: .feedingInstructions)
        medicationInstructions = try? container.decode(String.self, forKey: .medicationInstructions)
        isSprayed = try? container.decode(Bool.self, forKey: .isSprayed)
        hasMedication = try? container.decode(Bool.self, forKey: .hasMedication)
        character = try? container.decode(String.self, forKey: .character)
        locationOfLitterbox = try? container.decode(String.self, forKey: .locationOfLitterbox)
    }
    
    init(name: String, speciesType: String, gender: String, breed: String?, medicalNotes: String?, medicalRequirements: String?, veterinarian: [[String:String]]?, dob: Int?,age: Int?, feedingInstructions: String?, medicationInstructions: String?, isSpayed: Bool?, hasMedication: Bool?, character: String?, locationOfLitterbox: String?) {
        self.name = name
        self.speciesType = speciesType
        self.gender = gender
        self.breed = breed
        self.medicalNotes = medicalNotes
        self.medicalRequirements = medicalRequirements
        self.veterinarian = veterinarian
        self.age = age
        self.dob = dob
        self.feedingInstructions = feedingInstructions
        self.medicationInstructions = medicationInstructions
        self.isSprayed = isSpayed
        self.hasMedication = hasMedication
        self.character = character
        self.locationOfLitterbox = locationOfLitterbox
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["name"] = self.name
        parameters["speciesType"] = self.speciesType
        parameters["gender"] = self.gender
        parameters["breed"] = self.breed
        parameters["medicalNotes"] = self.medicalNotes
        parameters["medicalRequirements"] = self.medicalRequirements
        parameters["veterinarian"] = self.veterinarian
        parameters["age"] = self.age
        parameters["dob"] = self.dob
        parameters["feedingInstructions"] = self.feedingInstructions
        parameters["medicationInstructions"] = self.medicationInstructions
        parameters["isSpayed"] = self.isSprayed
        parameters["hasMedication"] = self.hasMedication
        parameters["character"] = self.character
        parameters["locationOfLitterbox"] = self.locationOfLitterbox
        return parameters
    }
}

struct CatStructAdd: Codable {
    var name: String
    var gender: String
    var speciesType: String
    var age: Int?
    var dob: Int?
    var breed: String?
    var medicalNotes: String?
    var medicalRequirements: String?
    var veterinarians: [[String: String]]?
    var feedingInstructions: String?
    var medicationInstructions: String?
    var isSprayed: Bool?
    var hasMedication: Bool?
//    var character: String?
    var locationOfLitterbox: String?
    
    enum CatStructCodingKeys: String, CodingKey {
        case name = "name"
        case gender = "gender"
        case breed = "breed"
        case speciesType = "speciesType"
        case medicalNotes = "medicalNotes"
        case medicalRequirements = "medicalRequirements"
        case veterinarians = "veterinarians"
        case age = "age"
        case dob = "dob"
        case feedingInstructions = "feedingInstructions"
        case medicationInstructions = "medicationInstructions"
        case isSprayed = "isSpayed"
        case hasMedication = "hasMedication"
//        case character = "character"
        case locationOfLitterbox = "locationOfLitterbox"
    }
    
    init(name: String, gender: String, speciesType: String, breed: String?, medicalNotes: String?, medicalRequirements: String?, veterinarians: [[String:String]]?, age: Int?, dob: Int?, feedingInstructions: String?, medicationInstructions: String?, isSpayed: Bool?, hasMedication: Bool?, locationOfLitterbox: String?) {
        self.name = name
        self.gender = gender
        self.speciesType = speciesType
        self.breed = breed
        self.medicalNotes = medicalNotes
        self.medicalRequirements = medicalRequirements
        self.veterinarians = veterinarians
        self.age = age
        self.dob = dob
        self.feedingInstructions = feedingInstructions
        self.medicationInstructions = medicationInstructions
        self.isSprayed = isSpayed
        self.hasMedication = hasMedication
//        self.character = character
        self.locationOfLitterbox = locationOfLitterbox
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["name"] = self.name
        parameters["gender"] = self.gender
        parameters["speciesType"] = self.speciesType
        parameters["breed"] = self.breed
        parameters["medicalNotes"] = self.medicalNotes
        parameters["medicalRequirements"] = self.medicalRequirements
        parameters["veterinarians"] = self.veterinarians
        parameters["dob"] = self.dob
        parameters["age"] = self.age
        parameters["feedingInstructions"] = self.feedingInstructions
        parameters["medicationInstructions"] = self.medicationInstructions
        parameters["isSpayed"] = self.isSprayed
        parameters["hasMedication"] = self.hasMedication
//        parameters["character"] = self.character
        parameters["locationOfLitterbox"] = self.locationOfLitterbox
        return parameters
    }
}

struct CatStruct: Codable {
    var name: String
    var gender: String
    var dob: Int?
    var age: Int?
    var breed: String?
    var medicalNotes: String?
    var medicalRequirements: String?
    var veterinarians: [[String: String]]?
    var feedingInstructions: String?
    var medicationInstructions: String?
    var isSprayed: Bool?
    var hasMedication: Bool?
    var character: String?
    var locationOfLitterbox: String?
    
    enum CatStructCodingKeys: String, CodingKey {
        case name = "name"
        case gender = "gender"
        case breed = "breed"
        case medicalNotes = "medicalNotes"
        case medicalRequirements = "medicalRequirements"
        case veterinarians = "veterinarians"
        case dob = "dob"
        case age = "age"
        case feedingInstructions = "feedingInstructions"
        case medicationInstructions = "medicationInstructions"
        case isSprayed = "isSpayed"
        case hasMedication = "hasMedication"
        case character = "character"
        case locationOfLitterbox = "locationOfLitterbox"
    }
    
    init(name: String, gender: String, breed: String?, medicalNotes: String?, medicalRequirements: String?, veterinarians: [[String:String]]?, age: Int?,dob: Int?, feedingInstructions: String?, medicationInstructions: String?, isSpayed: Bool?, hasMedication: Bool?, locationOfLitterbox: String?) {
        self.name = name
        self.gender = gender
        self.breed = breed
        self.medicalNotes = medicalNotes
        self.medicalRequirements = medicalRequirements
        self.veterinarians = veterinarians
        self.age = age
        self.dob = dob
        self.feedingInstructions = feedingInstructions
        self.medicationInstructions = medicationInstructions
        self.isSprayed = isSpayed
        self.hasMedication = hasMedication
//        self.character = character
        self.locationOfLitterbox = locationOfLitterbox
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["name"] = self.name
        parameters["gender"] = self.gender
        parameters["breed"] = self.breed
        parameters["medicalNotes"] = self.medicalNotes
        parameters["medicalRequirements"] = self.medicalRequirements
        parameters["veterinarians"] = self.veterinarians
        parameters["age"] = self.age
        parameters["dob"] = self.dob
        parameters["feedingInstructions"] = self.feedingInstructions
        parameters["medicationInstructions"] = self.medicationInstructions
        parameters["isSpayed"] = self.isSprayed
        parameters["hasMedication"] = self.hasMedication
//        parameters["character"] = self.character
        parameters["locationOfLitterbox"] = self.locationOfLitterbox
        return parameters
    }
}

struct AllPets: Codable {
    var pets: [PetUniversal]
    
    enum AllPetsCodingKey: String, CodingKey {
        case pets = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AllPetsCodingKey.self)
        pets = try container.decode([PetUniversal].self, forKey: .pets)
    }
}

struct Vaccine: Codable {
    var items: [VaccineStruct]
    
    enum VaccineCodingKey: String, CodingKey {
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: VaccineCodingKey.self)
        items = try container.decode([VaccineStruct].self, forKey: .items)
    }
}

struct PetsProfile: Codable {
    var speciesType: String
    
    enum AllPetsCodingKey: String, CodingKey {
        case speciesType = "speciesType"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AllPetsCodingKey.self)
        speciesType = try container.decode(String.self, forKey: .speciesType)
    }
}

struct Meta: Codable {
    let totalItems, itemCount, itemsPerPage, totalPages: Int
    let currentPage: Int
}

struct TestStruct: Codable {
    var pets: [TestUniversal]
    var meta: Meta
    
    enum TestCodingKey: String, CodingKey {
        case pets = "items"
        case meta = "meta"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestCodingKey.self)
        pets = try container.decode([TestUniversal].self, forKey: .pets)
        meta = try container.decode(Meta.self, forKey: .meta)
    }
}

struct PetOrdersStruct: Codable {
    var pets: [PetForOrder]
    var meta: Meta
    
    enum PetOrdersKey: String, CodingKey {
        case pets = "pets"
        case meta = "meta"
    }
}

struct Holidays: Codable {
    var pets: [HolidaysStruct]
    
    enum HolidaysCodingKey: String, CodingKey {
        case pets = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HolidaysCodingKey.self)
        pets = try container.decode([HolidaysStruct].self, forKey: .pets)
    }
}

struct CustomerGetEmployeeProfile: Codable {
    var profile: [HolidaysStruct]
    
    enum CustomerGetEmployeeProfileCodingKey: String, CodingKey {
        case profile = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomerGetEmployeeProfileCodingKey.self)
        profile = try container.decode([HolidaysStruct].self, forKey: .profile)
    }
}

struct EmployeeProfile: Codable {
    var id: String
    var name: String
    var surname: String
    var imageUrl: String?
    var rating: Double?
    var wasOrderRated: Bool
    var comments: [Comment]
    
    enum EmployeeProfileCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case surname = "surname"
        case imageUrl = "imageUrl"
        case rating = "rating"
        case wasOrderRated = "wasOrderRated"
        case comments = "comments"
    }
}

struct Comment: Codable {
    var id: String
    var name: String
    var surname: String
    var imageUrl: String?
    var rating: Double?
    var comment: String?
    
    enum CommentCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case surname = "surname"
        case imageUrl = "imageUrl"
        case rating = "rating"
        case comment = "comment"
    }
}

struct HolidaysStruct: Codable {
    var day: Int
    var month: Int
    var feeAmount: Int

    enum HolidaysStructCodingKeys: String, CodingKey {
        case day = "day"
        case month = "month"
        case feeAmount = "feeAmount"
    }
}

struct TestUniversal: Codable {
    var id: String
    var name: String
    var breed: String?
    var gender: String
    var imageUrl: String?
    
    enum TestUnCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case breed = "breed"
        case gender = "gender"
        case imageUrl = "imageUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestUnCodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        breed = try? container.decode(String.self, forKey: .breed)
        gender = try container.decode(String.self, forKey: .gender)
        imageUrl = try? container.decode(String.self, forKey: .imageUrl)
    }
}

struct PetOrders: Codable {
    var id: String
    var name: String
    var breed: String?
    var imageUrl: String?
    
    enum TestUnCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case breed = "breed"
        case imageUrl = "imageUrl"
    }
}
