//
//  PetsUniversal.swift
//  p103-customer
//
//  Created by Alex Lebedev on 07.08.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation

struct ChecklistDetails: Codable {
    var id: String
    var name: String
    var numOrder: Int
    var imageUrl: String?
    var attachmentUrls: [String]
    var actions: [Actions]
   
    enum ChecklistDetailsKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case numOrder = "numOrder"
        case imageUrl = "imageUrl"
        case attachmentUrls = "attachmentUrls"
        case actions = "actions"
        
    }
}

struct Actions: Codable {
    var name: String
    var time: Int
    
    enum ActionsKeys: String, CodingKey {
        case name = "name"
        case time = "time"
    }
}

struct Histories: Codable {
    var id: String
    var timeFrom: Int
    var timeTo: Int
    var status: String
    var pets: [PetsId]
    var service: ServiceId
    var employee: EmployeeInfo?
    var reason: String?
//    var meta: Meta
    
    enum HistoriesKeys: String, CodingKey {
        case id = "id"
        case timeFrom = "timeFrom"
        case timeTo = "timeTo"
        case status = "status"
        case pets = "pets"
        case service = "service"
        case employee = "employee"
        case reason = "reason"
//        case meta = "meta"
    }
}

struct UpcomingDetailsOrder: Codable {
    var id: String
    var dateFrom: Int64
    var dateTo: Int64
    var status: String
    var pets: [PetsId]
    var service: ServiceId
    var totalAmount: Int
    var createdAt: Double
    
    enum UpcomingDetailsKeys: String, CodingKey {
        case id = "id"
        case service = "service"
        case status = "status"
        case pets = "pets"
        case dateFrom = "dateFrom"
        case dateTo = "dateTo"
        case totalAmount = "totalAmount"
        case createdAt = "createdAt"
    }
}

struct UpcomingOrders: Codable {
    var id: String
    var service: ServiceId
    var status: String
    var pets: [PetsId]
    var dateFrom: Int64
    var dateTo: Int64
    var employee: EmployeeInfo?
    var isFirstMeet: Bool

    enum UpcomingKeys: String, CodingKey {
        case id = "id"
        case service = "service"
        case status = "status"
        case pets = "pets"
        case dateFrom = "dateFrom"
        case dateTo = "dateTo"
        case employee = "employee"
        case isFirstMeet = "isFirstMeet"
    }
}

struct EmployeeInfo: Codable {
    var id: String
    var name: String
    var surname: String
    var rating: Double?
    var imageUrl: String?
    enum EmployeeInfo: String, CodingKey {
        case id = "id"
        case name = "name"
        case surname = "surname"
        case rating = "rating"
        case imageUrl = "imageUrl"
    }
}

struct VaccineStruct: Codable {
    var id: String
    var imageUrl: String
    
    enum VaccineStructCodingKeys: String, CodingKey {
        case id = "id"
        case imageUrl = "imageUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: VaccineStructCodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
}

struct PetUniversal: Codable {
    var id: String
    var name: String
    var breed: String
    var gender: String
    var imageUrl: String?
    
    enum PetUniversalCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case breed = "breed"
        case gender = "gender"
        case imageUrl = "imageUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PetUniversalCodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        breed = try container.decode(String.self, forKey: .breed)
        gender = try container.decode(String.self, forKey: .gender)
        imageUrl = try? container.decode(String.self, forKey: .imageUrl)
    }
}

struct Emergences: Codable {
    var id: String
    var name: String
    var phoneNumber: String
    
    enum EmergencesCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case phoneNumber = "phoneNumber"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EmergencesCodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
    }
}

struct OrderDetails: Codable {
    var firstDate: Int
    var lastDate: Int
    var comment: String?
    var service: ServiceId
    var status: String
    var pets: [PetsId]
    var visits: [VisitsId]
    var orders: [OrdersId]
    var createdAt: Double
    var total: TotalAmount

    enum OrderDetailsKeys: String, CodingKey {
        case firstDate = "firstDate"
        case lastDate = "lastDate"
        case comment = "comment"
        case service = "service"
        case status = "status"
        case pets = "pets"
        case visits = "visits"
        case orders = "orders"
        case total = "total"
        case createdAt = "createdAt"
    }
}

struct TotalAmount: Codable {
    var totalAmount: Int
    var holidays: [HolidayOrderDetailStruct]?
    var extras: [ExtrasTotal]?
    
    enum TotalAmountKeys: String, CodingKey {
        case totalAmount = "totalAmount"
        case holidays = "holidays"
        case extras = "extras"
    }
}

struct ExtrasTotal: Codable {
    var name: String
    var price: Int
    
    enum ExtrasTotalKeys: String, CodingKey {
        case name = "name"
        case price = "price"
    }
}

struct HolidayOrderDetailStruct: Codable {
    var price: Int
    var date: Int
    
    enum HolidayOrderDetailStructKeys: String, CodingKey {
        case price = "price"
        case date = "date"
    }
}

class Orders: Codable {
    var id: String
    var firstDate: Int
    var lastDate: Int
    var service: ServiceId
    var status: String
    var pets: [PetsId]
    var visits: [VisitsId]
    var orders: [OrdersId]
    
    enum OrdersKeys: String, CodingKey {
        case id = "id"
        case firstDate = "firstDate"
        case lastDate = "lastDate"
        case service = "service"
        case status = "status"
        case pets = "pets"
        case visits = "visits"
        case orders = "orders"
    }
    
}

struct ServiceId: Codable {
    var id: String
    var title: String
    var imageUrl: String?
    var price: Int?
    
    enum ServiceIdKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case imageUrl = "imageUrl"
        case price = "price"
    }
}

struct PetsId: Codable {
    var id: String
    var name: String
    var imageUrl: String?
    
    enum PetsIdKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case imageUrl = "imageUrl"
    }
}

struct PetsBreedId: Codable {
    var id: String
    var name: String
    var breed: String?
    var imageUrl: String?
    
    enum PetsIdKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case imageUrl = "imageUrl"
        case breed = "breed"
    }
}


class VisitsId: Codable {
    var timeFrom: Int
    var timeTo: Int
    var type: String
    
    enum VisitsIdKeys: String, CodingKey {
        case timeFrom = "timeFrom"
        case timeTo = "timeTo"
        case type = "type"
    }
  
}

class OrdersId: Codable {
    var id: String
    var dateFrom: Int
    var dateTo: Int
    var status: String
    //Locally manage the modal
    var visit: VisitsId?
    
    enum OrdersIdKeys: String, CodingKey {
        case id = "id"
        case dateFrom = "dateFrom"
        case dateTo = "dateTo"
        case status = "status"
//        case visit
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OrdersIdKeys.self)
        id = try container.decode(String.self, forKey: .id)
        dateFrom = try container.decode(Int.self, forKey: .dateFrom)
        dateTo = try container.decode(Int.self, forKey: .dateTo)
        status = try container.decode(String.self, forKey: .status)
//        visit = try container.decode(VisitsId.self, forKey: .visit)
    }
    func updateVisit(visit: VisitsId?) {
        self.visit = visit
    }
}

struct SelectionServices: Codable {
    var id: String
    var title: String
    var services: [ListOfServices]
    var imageUrl: String?
     
    enum SelectionCodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case services = "services"
        case imageUrl = "imageUrl"
        
    }
}

struct ExtraServices: Codable {
    var id: String
    var title: String
    var description: String
    var price: Int
    var imageUrl: String?
    
    enum ExtraServicesCodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case price = "price"
        case imageUrl = "imageUrl"
    }
}

struct ListOfServices: Codable {
    var id: String
    var title: String
    var description: String
    var imageUrl: String?
    var speciesType: [String]
    var sizeType: String?
    var price: Int
    var subcategory: [String: String]?
    
    enum ListOfServicesCodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case imageUrl = "imageUrl"
        case speciesType = "speciesTypes"
        case sizeType = "sizeType"
        case price = "price"
        case subcategory = "subcategory"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ListOfServicesCodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        imageUrl = try? container.decode(String.self, forKey: .imageUrl)
        speciesType = try container.decode([String].self, forKey: .speciesType)
        sizeType = try? container.decode(String.self, forKey: .sizeType)
        price = try container.decode(Int.self, forKey: .price)
        subcategory = try? container.decode([String: String].self, forKey: .subcategory)
    }
}


