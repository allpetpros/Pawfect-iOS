//
//  Auth.swift
//  p103-customer
//
//  Created by Alex Lebedev on 16.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import Moya

struct HistoriesDetails: Decodable {
    var id: String
    var timeFrom: Int
    var timeTo: Int
    var totalDuration: Int
    var pets: [PetsId]
    var employee: EmployeeInfo?
    var checklist: [ChecklistDetails]
    var reason: String?
    
    enum HistoriesDetailsKeys: String, CodingKey {
        case id = "id"
        case timeFrom = "timeFrom"
        case timeTo = "timeTo"
        case totalDuration = "totalDuration"
        case pets = "pets"
        case employee = "employee"
        case checklist = "checklist"
        case reason = "reason"
    }
}

struct HistoriesResponse: Decodable {
    var items: [Histories]
    var meta: Meta
    
    enum HistoriesResponseKeys: String, CodingKey {
        case items = "items"
        case meta = "meta"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HistoriesResponseKeys.self)
        items = try container.decode([Histories].self, forKey: .items)
        meta = try container.decode(Meta.self, forKey: .meta)
    }
    
}

struct UpcomingResponse: Decodable {
    var items: [UpcomingOrders]
    var meta: Meta
    
    enum UpcomingResponseKeys: String, CodingKey {
        case items = "items"
        case meta = "meta"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UpcomingResponseKeys.self)
        items = try container.decode([UpcomingOrders].self, forKey: .items)
        meta = try container.decode(Meta.self, forKey: .meta)
    }
}

class OrdersResponse: Decodable {
    var items: [Orders]
    var meta: Meta
    
    enum OrdersResponseKeys: String, CodingKey {
        case items = "items"
        case meta = "meta"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OrdersResponseKeys.self)
        items = try container.decode([Orders].self, forKey: .items)
        meta = try container.decode(Meta.self, forKey: .meta)
    }
}

struct EmergenciesGetResponse: Decodable {
    var items: [Emergences]
    
    enum EmergenciesGetResponseKeys: String, CodingKey {
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EmergenciesGetResponseKeys.self)
        items = try container.decode([Emergences].self, forKey: .items)
    }
}

struct ServicesGetResponse: Decodable {
    var items: [SelectionServices]
    
    enum ServicesGetResponseKeys: String, CodingKey {
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ServicesGetResponseKeys.self)
        items = try container.decode([SelectionServices].self, forKey: .items)
    }
}

struct ExtrasResponse: Decodable {
    var items: [ExtraServices]
    
    enum ExtrasResponseKeys: String, CodingKey {
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ExtrasResponseKeys.self)
        items = try container.decode([ExtraServices].self, forKey: .items)
    }
}


struct ErrorResponse: Decodable, Error {
    
    var localizedDescription: String
    
    enum ErrorResponseKeys: String, CodingKey {
        case localizedDescription = "message"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ErrorResponseKeys.self)
        localizedDescription = try container.decode(String.self, forKey: .localizedDescription)
    }
}
struct SuccessResponse: Decodable {
    
    var success: Bool
    
    enum ErrorResponseKeys: String, CodingKey {
        case success = "success"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ErrorResponseKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
    }
}

struct MeetNGreetGetStatusResponse: Decodable {
    
    var status: Int
    var time: Int
    
    enum ErrorResponseKeys: String, CodingKey {
        case status = "status"
        case time = "time"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ErrorResponseKeys.self)
        status = try container.decode(Int.self, forKey: .status)
        time = try container.decode(Int.self, forKey: .time)
    }
}

struct MeetNGreetDetailResponse: Codable {
    let meetNGreetDetailItem: [MeetNGreetDetailItem]
}

struct MeetNGreetDetailItem: Codable {
    let id, title, itemDescription: String
    let price: Int

    enum CodingKeys: String, CodingKey {
        case id, title
        case itemDescription = "description"
        case price
    }
}


struct URLResponse: Decodable {
    var url: String
    
    enum URLResponseKeys: String, CodingKey {
        case url = "url"
    }
}

struct ZipResponse: Decodable {
    
    var success: Bool

    enum ErrorResponseKeys: String, CodingKey {
        case success = "isExist"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ErrorResponseKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
    }
}

struct RegistrationResponse: Decodable {
    
    var accesToken: String
    
    enum RegistrationResponseKeys: String, CodingKey {
        case accesToken = "accessToken"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RegistrationResponseKeys.self)
        accesToken = try container.decode(String.self, forKey: .accesToken)
    }
}

struct RegistrationStepResponse: Decodable {
    
    var accesToken: String
  
    
    enum RegistrationResponseKeys: String, CodingKey {
        case accesToken = "accessToken"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RegistrationResponseKeys.self)
        accesToken = try container.decode(String.self, forKey: .accesToken)
    }
}

struct AddInfoResponse: Decodable {
    
    var imageURL: String

    enum RegistrationResponseKeys: String, CodingKey {
        case imageURL = "url"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RegistrationResponseKeys.self)
        imageURL = try container.decode(String.self, forKey: .imageURL)
    }
}

struct AddAnimalResponse: Decodable {
    
    var id: String
    
    enum ErrorResponseKeys: String, CodingKey {
        case id = "id"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ErrorResponseKeys.self)
        id = try container.decode(String.self, forKey: .id)
    }
}

struct AddCardResponse: Decodable {
    
    var id: String
    
    enum AddCardResponseKeys: String, CodingKey {
        case id = "id"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AddCardResponseKeys.self)
        id = try container.decode(String.self, forKey: .id)
    }
}


struct SignInResponce: Decodable {
    
    var accessToken: String
    var role: String
    var name: String?
    var surname: String?
    var avatarUrl: String?
    var status: Int?
    
    enum RegistrationResponseKeys: String, CodingKey {
        case accessToken = "accessToken"
        case role = "role"
        case name = "name"
        case surname = "surname"
        case avatarUrl = "avatarUrl"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RegistrationResponseKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        role = try container.decode(String.self, forKey: .role)
        name = try? container.decode(String.self, forKey: .name)
        surname = try? container.decode(String.self, forKey: .surname)
        avatarUrl = try? container.decode(String.self, forKey: .avatarUrl)
        status = try? container.decode(Int.self, forKey: .status)
    }
    func isFillProfile() -> Bool {
        if name == nil || surname == nil || avatarUrl == nil {
            return false
        } else {
            return true
        }
    }
    
}
struct ForgotPasswordResponse: Decodable, Error {
    
    var emailValid: Bool
    
    enum ForgotPasswordResponseKeys: String, CodingKey {
        case emailValid = "success"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ForgotPasswordResponseKeys.self)
        emailValid = try container.decode(Bool.self, forKey: .emailValid)
    }
}


struct GetTransactionHistoryResponse: Codable {
    var items: [TransactionItem]
    let meta: Meta
}

// MARK: - Item
struct TransactionItem: Codable {
    let id: String
    let pets: [Pet]
    let totalAmount, createdAt: Int
}

// MARK: - Pet
struct Pet: Codable {
    let id, name: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "imageUrl"
    }
}

