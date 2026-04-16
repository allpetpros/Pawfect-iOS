//
//  ProfileStruct.swift
//  p103-customer
//
//  Created by Daria Pr on 18.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import Foundation

struct CancelOrder: Codable {
    var id: String
    var reason: String?
    var orderIds: [String]?
    
    enum CancelOrderOrdersKeys: String, CodingKey {
        case id = "id"
        case reason = "reason"
        case orderIds = "orderIds"
    }
    
    func convertToParams() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["id"] = self.id
        parameters["reason"] = self.reason
        parameters["orderIds"] = self.orderIds
        return parameters
    }
}

struct PetForOrder: Codable {
    var serviceId: String
    var onDates: [Int64]
    var visits: [Visit]
    
    enum PetForOrderKeys: String, CodingKey {
        case serviceId = "serviceId"
        case onDates = "onDates"
        case visits = "visits"
    }
    
    func convertToParams() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["serviceId"] = self.serviceId
        parameters["onDates"] = self.onDates
        parameters["visits"] = self.visits
        return parameters
    }
}

struct CreatingOrder: Codable {
    var serviceId: String
    var petIds: [String]
    var dates: [Int64]
    var comment: String?
    var extraIds: [String]?
    var visits: [Visit]
    
    enum CreatingOrderKeys: String, CodingKey {
        case serviceId = "serviceId"
        case petIds = "petIds"
        case dates = "dates"
        case comment = "comment"
        case extraIds = "extraIds"
        case visits = "visits"
    }
    
    func convertToEditCustomerParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["serviceId"] = self.serviceId
        parameters["petIds"] = self.petIds
        parameters["dates"] = self.dates
        parameters["visits"] = self.visits
        parameters["extraIds"] = self.extraIds
        parameters["comment"] = self.comment
        return parameters
    }
}

struct Order: Decodable {
    var id: String
    var petIds: [PetsId]
    var service: [ServiceId]
    var status: String
    var visits: [VisitId]
    var orders: [OrdersDetailsResponse]

    enum OrderKeys: String, CodingKey {
        case id = "id"
        case service = "service"
        case petIds = "pets"
        case status = "status"
        case visits = "visits"
        case extraIds = "extraIds"
        case comment = "comment"
    }
}

struct OrdersDetailsResponse: Decodable {
    var id: String
    var dateFrom: Int
    var dateTo: Int
    var status: String
    
    enum OrdersDetailsResponseKeys: String, CodingKey {
        case id = "id"
        case dateFrom = "dateFrom"
        case dateTo = "dateTo"
        case status = "status"
    }
}

struct VisitId: Codable {
    var type: String
    var timeFrom: Int
    var timeTo: Int
    
    enum VisitKeys: String, CodingKey {
        case type = "type"
        case timeFrom = "timeFrom"
        case timeTo = "timeTo"
    }

    
}

struct Visit: Codable {
    var type: String
    var time: Int
    
    enum VisitTestKeys: String, CodingKey {
        case type = "type"
        case time = "time"
    }

    init(type: String, time: Int) {
        self.type = type
        self.time = time
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: VisitTestKeys.self)

        type = try container.decode(String.self, forKey: .type)
        time = try container.decode(Int.self, forKey: .time)
    }
    
    
}

struct ProfileStruct: Decodable {
    
    var firstName: String
    var lastName: String
    var phone: String
    var workPhone: String?
    var address: String
    var billingAddress: String
    var isSameAddress: Bool?
    
    var city: String
    
    var state: String
    var homePosition: [String: Double]
    
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
    var hearAboutUs: String?
    var comment: String?
    var garbage: [String]?
    var status: Int?
    
    enum ProfileKeys: String, CodingKey {
        
        case firstName = "name"
        case lastName = "surname"
        case phone = "phoneNumber"
        case workPhone = "workPhoneNumber"
        case address = "address"
        case billingAddress = "billingAddress"
        case isSameAddress = "isSameAddress"
        case city = "city"
        case state = "state"
        case homePosition = "homePosition"
        
        case lockboxDoorCode = "lockboxDoorCode"
        case lockboxLocation = "lockboxLocation"
        case homeAlarmSystem = "homeAlarmSystem"
        case otherHomeAccessNotes = "otherHomeAccessNotes"
        case mailBox = "mailbox"
        case otherRequestsNotes = "otherRequestNotes"
        
        case isMailKeyProvided = "isMailKeyProvided"
        case isTurnLight = "isTurnLight"
        case isSomeoneAtHome = "isSomeoneWillBeAtHome"
        case isWaterPlantsExists = "isWaterPlantsExists"
        case hearAboutUs = "hearAboutUs"
        case comment = "comment"
        case garbage = "garbages"
        case status = "status"
    }
    
    init(firstName: String, lastName: String, phone: String, workPhone: String, address: String, billingAddress: String, isSameAddress:Bool?, city: String, state: String, homePosition: [String: Double], lockboxDoorCode: String?, lockboxLocation: String?, homeAlarmSystem: String?, otherHomeAccessNotes: String?, mailBox: String?, otherRequestsNotes: String?, isMailKeyProvided: Bool?, isTurnLight: Bool?, isSomeoneAtHome: Bool?, isWaterPlantsExists: Bool?, hearAboutUs: String,comment: String?, garbage: [String]?, status: Int?) {
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.workPhone = workPhone
        self.address = address
        self.billingAddress = billingAddress
        self.isSameAddress = isSameAddress
        self.city = city
        self.state = state
        self.homePosition = homePosition
        self.lockboxDoorCode = lockboxDoorCode
        self.lockboxLocation = lockboxLocation
        self.homeAlarmSystem = homeAlarmSystem
        self.otherHomeAccessNotes = otherHomeAccessNotes
        self.mailBox = mailBox
        self.otherRequestsNotes = otherRequestsNotes
        self.isMailKeyProvided = isMailKeyProvided
        self.isTurnLight = isTurnLight
        self.isSomeoneAtHome = isSomeoneAtHome
        self.isWaterPlantsExists = isWaterPlantsExists
        self.hearAboutUs = hearAboutUs
        self.comment = comment
        self.garbage = garbage
        self.status = status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProfileKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        phone = try container.decode(String.self, forKey: .phone)
        address = try container.decode(String.self, forKey: .address)
        billingAddress = try container.decode(String.self, forKey: .billingAddress)
       
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        
        lockboxDoorCode = try? container.decode(String.self, forKey: .lockboxDoorCode)
        lockboxLocation = try? container.decode(String.self, forKey: .lockboxLocation)
        homeAlarmSystem = try? container.decode(String.self, forKey: .homeAlarmSystem)
        
        homePosition = try container.decode([String: Double].self, forKey: .homePosition)
        
        otherHomeAccessNotes = try? container.decode(String.self, forKey: .otherHomeAccessNotes)
        mailBox = try? container.decode(String.self, forKey: .mailBox)
        otherRequestsNotes = try? container.decode(String.self, forKey: .otherRequestsNotes)
        
        isMailKeyProvided = try? container.decode(Bool.self, forKey: .isMailKeyProvided)
        isTurnLight = try? container.decode(Bool.self, forKey: .isTurnLight)
        isSomeoneAtHome = try? container.decode(Bool.self, forKey: .isSomeoneAtHome)
        isWaterPlantsExists = try? container.decode(Bool.self, forKey: .isWaterPlantsExists)
        
        comment = try? container.decode(String.self, forKey: .comment)
        garbage = try? container.decode(Array.self, forKey: .garbage)
        workPhone = try container.decode(String.self, forKey: .workPhone)
        hearAboutUs = try? container.decode(String.self, forKey: .hearAboutUs)
        status = try? container.decode(Int.self, forKey: .status)
    }
    
    func convertToEditCustomerParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["name"] = self.firstName
        parameters["surname"] = self.lastName
        parameters["phoneNumber"] = self.phone
        parameters["workPhoneNumber"] = self.workPhone
        parameters["homeAddress"] = self.address
        parameters["billingAddress"] = self.billingAddress
        parameters["isSameAddress"] = self.isSameAddress
        parameters["city"] = self.city
        parameters["state"] = self.state
        parameters["homePosition"] = self.homePosition
        parameters["lockboxDoorCode"] = self.lockboxDoorCode
        parameters["lockboxLocation"] = self.lockboxLocation
        parameters["homeAlarmSystem"] = self.homeAlarmSystem
        parameters["otherHomeAccessNotes"] = self.otherHomeAccessNotes
        parameters["mailbox"] = self.mailBox
        parameters["otherRequestNotes"] = self.otherRequestsNotes
        parameters["isMailKeyProvided"] = self.isMailKeyProvided
        parameters["isTurnLight"] = self.isTurnLight
        parameters["isSomeoneWillBeAtHome"] = self.isSomeoneAtHome
        parameters["isWaterPlantsExists"] = self.isWaterPlantsExists
        parameters["hearAboutUs"] = self.hearAboutUs
        parameters["comment"] = self.comment
        parameters["garbage"] = self.garbage
        parameters["status"] = self.status
        return parameters
    }
}
class CustomerMapResponse: Codable {
    let items: [Items]
    let meta: Meta

    init(items: [Items], meta: Meta) {
        self.items = items
        self.meta = meta
    }
}

// MARK: - Item
class Items: Codable {
    let id: String
    let mainOrderFirstDate, mainOrderLastDate: Int
    let status: String?
    let isFirstMeet: Bool?
    let dateFrom, dateTo: Int?
    let pets: [Pets]
    let service: Service?

    init(id: String, mainOrderFirstDate: Int, mainOrderLastDate: Int, status: String, isFirstMeet: Bool, dateFrom: Int, dateTo: Int, pets: [Pets], service: Service) {
        self.id = id
        self.mainOrderFirstDate = mainOrderFirstDate
        self.mainOrderLastDate = mainOrderLastDate
        self.status = status
        self.isFirstMeet = isFirstMeet
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.pets = pets
        self.service = service
    }
}

// MARK: - Pet
class Pets: Codable {
    let id, name: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "imageUrl"
    }

    init(id: String, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
}

// MARK: - Service
class Service: Codable {
    let id, title: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case imageURL = "imageUrl"
    }

    init(id: String, title: String, imageURL: String) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
    }
}


//MARK:- Customer Map Details


struct CustomerMapDetailResponse: Codable {
    let id, homeAddress: String
    let customerHomePosition: CustomerHomePosition
    let pets: [PetDetail]
    let employee: EmployeeDetail?
    let checklist: [ChecklistInfo]
    let points:[Points]
    let actionPoints: [ActionPoints]
}


// MARK: - CustomerHomePosition
struct CustomerHomePosition: Codable {
    let lat, long: Double
}

// MARK: - Employee
struct EmployeeDetail: Codable {
    let id, name, surname: String
    let rating: Double
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name, surname, rating
        case imageURL = "imageUrl"
    }
}

// MARK: - Pet
struct PetDetail: Codable {
    let id, name: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "imageUrl"
    }
}

