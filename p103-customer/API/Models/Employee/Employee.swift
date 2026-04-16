//
//  Employee.swift
//  p103-customer
//
//  Created by Alex Lebedev on 13.08.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation

struct CustomerProfile: Codable {
    var name: String
    var surname: String
    var email: String
    var imageUrl: String?
    var phoneNumber: String
    var workPhoneNumber: String
    var emergencies: [[String: String]]?
    var homePosition: HomeMapPosition
    var address: String
    var billingAddress: String
    var city: String
    var state: String
    var zipCode: String
    var lockboxDoorCode: String?
    var lockboxLocation: String?
    var homeAlarmSystem: String?
    var otherHomeAccessNotes: String?
    var mailbox: String?
    var otherRequests: String?
    var isMailKeyProvided: Bool?
    var isSomeoneWillBeAtHome: Bool?
    var isWaterPlantsExists: Bool?
    var comment: String?
    var garbages: [String]?
    
    enum CustomerProfileCodingKeys: String, CodingKey {
        case name = "name"
        case surname = "surname"
        case email = "email"
        case imageUrl = "imageUrl"
        case phoneNumber = "phoneNumber"
        case workPhoneNumber = "workPhoneNumber"
        case emergencies = "emergencies"
        case homePosition = "homePosition"
        case address = "address"
        case billingAddress = "billingAddress"
        case city = "city"
        case state = "state"
        case zipCode = "zipCode"
        case lockboxDoorCode = "lockboxDoorCode"
        case lockboxLocation = "lockboxLocation"
        case homeAlarmSystem = "homeAlarmSystem"
        case otherHomeAccessNotes = "otherHomeAccessNotes"
        case mailbox = "mailbox"
        case otherRequests = "otherRequests"
        case isMailKeyProvided = "isMailKeyProvided"
        case isSomeoneWillBeAtHome = "isSomeoneWillBeAtHome"
        case isWaterPlantsExists = "isWaterPlantsExists"
        case comment = "comment"
        case garbages = "garbages"
    }
}

struct PetStruct: Codable {
    
    var id: String
    var name: String
    var speciesType: String
    var imageUrl: String?
    var breed: String?
    var gender: String?
    var age: Int?
    var size: Int?
    var sizeType: String?
    var feedingInstructions: String?
    var onWalks: [String]?
    var onSomeoneEntry: [String]?
    var medicationInstructions: String?
    var isSprayed: Bool?
    var hasMedication: Bool?
    var medicalRequirements: String?
    var medicalNotes: String?
    var veterinarian: Veterinarian?
    var isDoggyDoorExists: Bool?
    var character: String?
    var locationOfLitterbox: String?
    var vaccinations: [Vaccinations]?
    
    enum PetStructCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case speciesType = "speciesType"
        case imageUrl = "imageUrl"
        case breed = "breed"
        case gender = "gender"
        case age = "age"
        case size = "size"
        case sizeType = "sizeType"
        case feedingInstructions = "feedingInstructions"
        case onWalks = "onWalks"
        case onSomeoneEntry = "onSomeoneEntry"
        case medicationInstructions = "medicationInstructions"
        case isSprayed = "isSprayed"
        case hasMedication = "hasMedication"
        case medicalRequirements = "medicalRequirements"
        case veterinarian = "veterinarian"
        case isDoggyDoorExists = "isDoggyDoorExists"
        case character = "character"
        case locationOfLitterbox = "locationOfLitterbox"
        case vaccinations = "vaccinations"
    }
}

struct Vaccinations: Codable {
    var id: String
    var imageUrl: String
    
    enum VaccinationsCodingKeys: String, CodingKey {
        case id = "id"
        case imageUrl = "imageUrl"
    }
}

struct Veterinarian: Codable {
    var id: String
    var name: String
    var phoneNumber: String
    
    enum VeterinarianCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case phoneNumber = "phoneNumber"
    }
}

struct MapPosition: Codable {
    var positions: [PositionsStruct]
    
    enum MapPositionCodingKeys: String, CodingKey {
        case positions = "positions"
    }
}

struct PositionsStruct: Codable {
    var lat: Double
    var long: Double
    var createdAt: Int64
    
    enum PositionsStructCodingKeys: String, CodingKey {
        case lat = "lat"
        case long = "long"
        case createdAt = "createdAt"
    }
    
    init(lat:Double,long: Double,createdAt:Int64) {
        self.lat = lat
        self.long = long
        self.createdAt = createdAt
    }
   
}

extension Encodable {
    func data(using encoder: JSONEncoder = .init()) throws -> Data { try encoder.encode(self) }
    func dictionary(using encoder: JSONEncoder = .init(), options: JSONSerialization.ReadingOptions = []) throws -> [String: Any] {
        try JSONSerialization.jsonObject(with: try data(using: encoder), options: options) as? [String: Any] ?? [:]
    }
}

struct CurrentOrderMapDetails: Codable {
    var id: String
    var homeAddress: String
    var customerHomePosition: HomeMapPosition
    var pets: [PetsBreedId]
    var employee: EmployeeInfo
    var checklist: [ChecklistInfo]
    var points: [Points]
    var actionPoints: [ActionPoints]?
    
    enum CurrentOrderMapDetailsCodingKeys: String, CodingKey {
        case id = "id"
        case homeAddress = "homeAddress"
        case customerHomePosition = "customerHomePosition"
        case pets = "pets"
        case employee = "employee"
        case checklist = "checklist"
        case points = "points"
//        case actionPoints = "actionPoints"
    }
}

struct HomeMapPosition: Codable {
    var lat: Double
    var long: Double
 
    enum HomePositionsKeys: String, CodingKey {
        case lat = "lat"
        case long = "long"
    }
}

struct ChecklistInfo: Codable {
    var id: String
    var name: String
    var numOrder: Int
    var dateStart: Int?
    var dateEnd: Int?
    var imageUrl: String?
    var duration: Int
    var trackDuration: Int
    var attachmentUrls: [String]?
    var actions: [Actions]?
    var status: String?
    
    enum ChecklistInfoCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case numOrder = "numOrder"
        case dateStart = "dateStart"
        case dateEnd = "dateEnd"
        case imageUrl = "imageUrl"
        case duration = "duration"
        case trackDuration = "trackDuration"
        case attachmentUrls = "attachmentUrls"
        case actions = "actions"
    }
}

struct Points: Codable {
    var createdAt: Int
    var lat: Double?
    var long: Double?
    let name: String?
    
    enum PointsCodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case lat = "lat"
        case long = "long"
        case name = "name"
    }
}

struct ActionPoints: Codable {
    var createdAt: Int
    var lat: Double?
    var long: Double?
    let name: String?
    
    enum ActionPointsCodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case lat = "lat"
        case long = "long"
        case name = "name"
    }
}

struct CurrentOrdersMap: Codable {
    var items: [MapOrders]
//    var meta: Meta
    
    enum CurrentOrderKeys: String, CodingKey {
        case items = "items"
//        case meta = "meta"
    }
}

struct MapOrders: Codable {
    var id: String
    var mainOrderFirstDate: Int
    var mainOrderLastDate: Int
    var status: String
    var isFirstMeet: Bool
    var dateFrom: Int
    var dateTo: Int
    var pets: [PetsId]
    var service: ServiceId
    
    enum MapOrdersCodingKeys: String, CodingKey {
        case id = "id"
        case mainOrderFirstDate = "mainOrderFirstDate"
        case mainOrderLastDate = "mainOrderLastDate"
        case status = "status"
        case isFirstMeet = "isFirstMeet"
        case dateFrom = "dateFrom"
        case dateTo = "dateTo"
        case pets = "pets"
        case service = "service"
    }
}

struct HistoryDetailsOrder: Codable {
    var id: String
    var timeFrom: Int
    var timeTo: Int
    var totalDuration: Int
    var pets: [PetsId]
    var customer: CustomerHistoryDetails
    var checklist: [Checklist]
    
    enum HistoryDetailsOrderKeys: String, CodingKey {
        case id = "id"
        case timeFrom = "timeFrom"
        case timeTo = "timeTo"
        case totalDuration = "totalDuration"
        case pets = "pets"
        case customer = "customer"
        case checklist = "checklist"
    }
}

struct Checklist: Codable {
    var id: String
    var name: String
    var numOrder: Int
    var imageUrl: String?
    var attachmentUrls: [String]
    var actions: [Actions]?
    
    enum ChecklistKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case numOrder = "numOrder"
        case imageUrl = "imageUrl"
        case attachmentUrls = "attachmentUrls"
        case actions = "actions"
    }
}

struct EmployeeHistoryOrders: Codable {
    var items: [EmployeeHistoryDetails]
    var meta: Meta
    
    enum EmployeeHistoryOrdersKeys: String, CodingKey {
        case items = "items"
        case meta = "meta"
    }
}

struct EmployeeHistoryDetails: Codable {
    var id: String
    var isFirstMeeting: Bool
    var timeFrom: Int
    var timeTo: Int
    var status: String
    var pets: [PetsId]
    var service: ServiceId
    var customer: CustomerHistoryDetails?
    
    enum EmployeeHistoryDetailsKeys: String, CodingKey {
        case id = "id"
        case isFirstMeeting = "isFirstMeeting"
        case timeFrom = "timeFrom"
        case timeTo = "timeTo"
        case status = "status"
        case pets = "pets"
        case service = "service"
        case customer = "customer"
    }
}

struct CustomerHistoryDetails: Codable {
    var id: String
    var name: String
    var surname: String
    var imageUrl: String?
    
    enum CustomerHistoryDetailsCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case surname = "surname"
        case imageUrl = "imageUrl"
    }
}

struct EmployeeConfirmedOrders: Codable {
    var items: [EmployeeConfirmedItems]
    var meta: Meta
    
    enum EmployeeConfirmedOrdersKeys: String, CodingKey {
        case items = "items"
        case meta = "meta"
    }
}

struct EmployeeDetailsConfirmed: Codable {
    var id: String
    var status: String
    var dateFrom: Int
    var dateTo: Int
    var customerId: String
    var comment: String?
    var totalAmount: Int
    var pets: [PetsEmployee]
    var service: ServiceId
    
    enum EmployeeDetailsConfirmedKeys: String, CodingKey {
        case id = "id"
        case status = "status"
        case dateFrom = "dateFrom"
        case dateTo = "dateTo"
        case customerId = "customerId"
        case comment = "comment"
        case totalAmount = "totalAmount"
        case pets = "pets"
        case service = "service"
    }
}

struct EmployeeConfirmedItems: Codable {
    var id: String
    var status: String
    var dateFrom: Int
    var dateTo: Int
    var isFirstMeet: Bool
    var pets: [PetsEmployee]
    var service: ServiceId
    var customer: CustomerConfirmed
    
    enum EmployeeConfirmedOrdersCodingKeys: String, CodingKey {
        case id = "id"
        case status = "status"
        case dateFrom = "dateFrom"
        case dateTo = "dateTo"
        case isFirstMeet = "isFirstMeet"
        case pets = "pets"
        case service = "service"
        case customer = "customer"
    }
}

struct CustomerConfirmed: Codable {
    var id: String
    var name: String
    var surname: String
    var phoneNumber: String
    var imageUrl: String?
    
    enum CustomerConfirmedCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case surname = "surname"
        case phoneNumber = "phoneNumber"
        case imageUrl = "imageUrl"
    }
}

struct EmployeeDetails: Codable {
    var id: String
    var isFirstMeeting: Bool
    var timeFrom: Int
    var timeTo: Int
    var status: String
    var customer: CustomerOrdersDetails
    var pets: [PetsId]
    var service: ServiceId
    
    enum EmployeeDetailsCodingKeys: String, CodingKey {
        case id = "id"
        case timeFrom = "timeFrom"
        case timeTo = "timeTo"
        case customer = "customer"
        case status = "status"
        case pets = "pets"
        case service = "service"
    }
}

struct CustomerOrdersDetails: Codable {
    var id: String
    var name: String
    var surname: String
    var homeAddress: String
    var imageUrl: String?
    
    enum CustomerOrdersDetailsCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case surname = "surname"
        case homeAddress = "homeAddress"
        case imageUrl = "imageUrl"
    }
}

struct EmployeeOrders: Codable {
    var items: [EmployeeOrderItems]
    
    enum EmployeeOrdersKeys: String, CodingKey {
        case items = "items"
    }
}

struct Rating: Codable {
    var items: [RatingItems]
    
    enum RatingCodingKeys: String, CodingKey {
        case items = "items"
    }
}

struct EmployeeOrderItems: Codable {
    var id: String
    var status: String
    var timeFrom: Int
    var timeTo: Int
    var pets: [PetsEmployee]
    var service: ServiceId
    
    enum EmployeeOrderItemsCodingKeys: String, CodingKey {
        case id = "id"
        case status = "status"
        case timeFrom = "timeFrom"
        case timeTo = "timeTo"
        case pets = "pets"
        case service = "service"
    }
}

struct PetsEmployee: Codable {
    var id: String
    var name: String
    var breed: String?
    var imageUrl: String?
    
    enum PetsEmployeeKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case breed = "breed"
        case imageUrl = "imageUrl"
    }
}

struct RatingItems: Codable {
    var id: String
    var name: String
    var surname: String
    var rate: Double?
    var comment: String?
    
    enum RatingItems: String, CodingKey {
        case id = "id"
        case name = "name"
        case surname = "surname"
        case rate = "rate"
        case comment = "comment"
    }
}

struct EmployeeGet: Codable {
    
    var email: String
    var name: String
    var surname: String
    var id: String
    var phoneNumber: String
    var address: String
    var workTimeFrom: Int
    var workTimeTo: Int
    var jobRate: Int
    var emergencies: [EmergenciesGet]
    
    enum EmployeeGetCodingKeys: String, CodingKey {
        case email = "email"
        case name = "name"
        case surname = "surname"
        case id = "id"
        case phoneNumber = "phoneNumber"
        case address = "address"
        case workTimeFrom = "workTimeFrom"
        case workTimeTo = "workTimeTo"
        case jobRate = "jobRate"
        case emergencies = "emergencies"
    }
}


struct EmergenciesGet: Codable {
    var id: String
    var name: String
    var phoneNumber: String
    
    enum EmergenciesGetCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case phoneNumber = "phoneNumber"
    }
}

struct Employee: Codable {
    
    var email: String
    var name: String
    var surname: String
    var homeAddress: String
    var phoneNumber: String
    var workFromInMS: Int
    var workToInMS: Int
    var emergences: [Emergence]
    
    var workIntervalString: String {

        let timeFrom: (h: Int, m: Int, s: Int) = ((workFromInMS / 1000) / 3600, ((workFromInMS / 1000) % 3600) / 60, ((workFromInMS / 1000) % 3600000) % 60)
        let timeTo: (h: Int, m: Int, s: Int) = ((workToInMS / 1000) / 3600, ((workToInMS / 1000) % 3600) / 60, ((workToInMS / 1000) % 3600000) % 60)
        
        let hFrom = timeFrom.h > 9 ? "\(timeFrom.h)" : "0\(timeFrom.h)"
        let hTo = timeTo.h > 9 ? "\(timeTo.h)" : "0\(timeTo.h)"
        
        let mFrom = timeFrom.m > 9 ? "\(timeFrom.m)" : "0\(timeFrom.m)"
        let mTo = timeTo.m > 9 ? "\(timeTo.m)" : "0\(timeTo.m)"
        
        return "\(hFrom):\(mFrom)-\(hTo):\(mTo)"
    }
    
    enum EmployeeCodingKeys: String, CodingKey {
        case email = "email"
        case name = "name"
        case surname = "surname"
        case homeAddress = "homeAddress"
        case phoneNumber = "phoneNumber"
        case workFromInMS = "workFrom"
        case workToInMS = "workTo"
        case emergences = "emergencies"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EmployeeCodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.name = try container.decode(String.self, forKey: .name)
        self.surname = try container.decode(String.self, forKey: .surname)
        self.homeAddress = try container.decode(String.self, forKey: .homeAddress)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.workFromInMS = try container.decode(Int.self, forKey: .workFromInMS)
        self.workToInMS = try container.decode(Int.self, forKey: .workToInMS)
        self.emergences = try container.decode([Emergence].self, forKey: .emergences)
    }
    init(employeeDB: EmployeeDB) {
        self.email = employeeDB.email
        self.name = employeeDB.name
        self.surname = employeeDB.surname
        self.homeAddress = employeeDB.homeAddress
        self.phoneNumber = employeeDB.phoneNumber
        self.workFromInMS = employeeDB.workFromInMS
        self.workToInMS = employeeDB.workToInMS
        self.emergences = employeeDB.emergences.map{ $0.convertToEmergenceLocal() }
    }
}

struct TimeOffs: Codable {
    var items: [TimeOffsItems]
    
    enum TimeOffsResponseKeys: String, CodingKey {
        case items = "items"
    }
}

struct TimeOffsItems: Codable {
    var id: String
    var dateChoiceType: String
    var timeOffType: String
    var dates: [Int]
    var notes: String
    var status: String
    
    enum TimeOffsItemsResponseKeys: String, CodingKey {
        case id = "id"
        case dateChoiceType = "dateChoiceType"
        case timeOffType = "timeOffType"
        case dates = "dates"
        case notes = "notes"
        case status = "status"
    }
}

struct TimeOffsAdding: Codable {
    var dateChoiceType: String
    var timeOffType: String
    var dates: [Int]
    var notes: String?
    
    enum TimeOffsAdding: String, CodingKey {
        case dateChoiceType = "dateChoiceType"
        case timeOffType = "timeOffType"
        case dates = "dates"
        case notes = "notes"
    }
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["dateChoiceType"] = dateChoiceType
        parameters["timeOffType"] = timeOffType
        parameters["dates"] = dates
        parameters["notes"] = notes
        return parameters
    }
}

struct TotalAmountCreditResponse: Codable {
    var amountEarned: Double
    
    enum TotalAmountCreditResponseKeys: String, CodingKey {
        case amountEarned = "amountEarned"
    }
}


struct AppointmentHistory: Codable {
    let items: [OrderHistoryItem]
    let meta: Meta
}

// MARK: - Item
struct OrderHistoryItem: Codable {
    let title: String
    let date: Int
    let amount: Double
}

struct MapSummaryStruct: Codable {
    var name: String
    var starttime: Int
 
    init(name:String,starttime: Int) {
        self.name = name
        self.starttime = starttime
    }
}
