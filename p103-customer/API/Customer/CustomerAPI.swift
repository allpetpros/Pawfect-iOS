//
//  CustomerAPI.swift
//  p103-customer
//
//  Created by Alex Lebedev on 29.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import Moya

enum CustomerAPI {
    case getProfile
    case getProfileShort
    case editProfile(_ newProfile: ProfileStruct)
    case changePassword(oldPass: String, newPass: String)
    case shareWithFriend(email: String)
    case deletePet(petId: String)
    
    case addAdditionalEmergency(name: String, phoneNumber: String)
    case getEmergencies
    case deleteEmergency(id: String)
    
    case getStatusOfMeetNGreet
    case getExtraMeetServiceDetail
    case createMeetGreetService(extraIds: String,date: Int)
//    case 
    
    case getServices
    case getExtraServices
    case createOrder(list: CreatingOrder)
    case getOrders(limit: Int, page: Int)
    case getHolidays(dateFrom: String, dateTo: String)
    case getOrderDetails(mainOrderId: String)
    case getUpcoming(date: Int, limit: Int, page: Int)
    case getUpcomingDetails(id: String)
    case getHistories(limit: Int, page: Int)
    case getHistoriesDetails(id: String)
    
    case rateEmployee(employeeId: String, orderId: String, comment: String?, rating: Double)
    case getEmployeeProfile(employeeId: String, orderId: String)
    
    case getEmployeeDetail(employeeId: String, orderId: String)
    
    case cancel(order: CancelOrder)
    case cancelSingleVisit(order: CancelOrder)
    case takePetForOrder(order: PetForOrder)
    case mapOrder
    case mapOrderDetail(id: String)
}

extension CustomerAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {      
        return URL(string: Constant.baseURL)!

    }
    
    var path: String {
        switch self {
            
        case .getProfile, .editProfile:
            return "/customer/profile/my"
        case .changePassword:
            return "/customer/profile/password-change"
        case .addAdditionalEmergency, .getEmergencies:
            return "/customer/profile/emergencies"
        case .getProfileShort:
            return "/customer/profile/my/short"
        case .shareWithFriend:
            return "/customer/profile/share"
        case .deletePet(let id):
            return "/customer/pets/\(id)"
        case .deleteEmergency(let id):
            return "/customer/profile/emergencies/\(id)"
        case .getStatusOfMeetNGreet:
            return "/customer/orders/status"
        case .getExtraMeetServiceDetail:
            return "/customer/services/extras/meet"
        case .createMeetGreetService:
            return "/customer/orders/first"
        case .getServices:
            return "/customer/services"
        case .getExtraServices:
            return "/customer/services/extras"
        case .createOrder, .getOrders:
            return "/customer/orders/"
        case .getHolidays:
            return "/customer/holidays/range"
        case .getOrderDetails(let mainOrderId):
            return "/customer/orders/\(mainOrderId)"
        case .getUpcoming:
            return "/customer/upcomings/"
        case .getUpcomingDetails(let id):
            return "/customer/upcomings/\(id)"
        case .getEmployeeProfile(let employeeId, let orderId):
            return "/customer/employees/\(employeeId)\(orderId)"
        case .getEmployeeDetail(let employeeId, _):
            return "/customer/employees/\(employeeId)"
        case .rateEmployee(employeeId: let id, _, _, _):
            return "/customer/employees/\(id)/rate"
        case .getHistories:
            return "/customer/histories/my"
        case .getHistoriesDetails(let id):
            return "/customer/histories/\(id)"
        case .cancel:
            return "/customer/orders/cancel/"
        case .cancelSingleVisit:
            return "customer/orders/cancel/order"
        case .takePetForOrder:
            return "/customer/pets/for-order"
        case .mapOrder:
            return "/customer/map"
        case .mapOrderDetail(let id):
            return "customer/map/\(id)"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProfile, .getProfileShort, .shareWithFriend, .getEmergencies, .getStatusOfMeetNGreet,.getExtraMeetServiceDetail,.getServices, .getExtraServices, .getOrders, .getHolidays, .getOrderDetails, .getUpcoming, .getUpcomingDetails, .getEmployeeProfile, .getEmployeeDetail,.getHistories, .getHistoriesDetails,.mapOrder,.mapOrderDetail:
            return .get
        case .editProfile:
            return .patch
        case .changePassword, .createMeetGreetService,.createOrder, .rateEmployee, .cancel, .cancelSingleVisit,.takePetForOrder:
            return .post
        case .addAdditionalEmergency:
            return .put
        case .deletePet, .deleteEmergency:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
             
        case .getProfile, .getProfileShort, .getEmergencies, .getStatusOfMeetNGreet,.getExtraMeetServiceDetail,.getServices, .getExtraServices, .getUpcomingDetails, .getHistoriesDetails,.mapOrder,.mapOrderDetail:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getOrders(let limit, let page):
            let parameters: [String: Any] = ["limit": limit, "page": page]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .editProfile(let blank):
            let parameters = blank.convertToEditCustomerParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .changePassword(let oldPass, let newPass):
            let parameters: [String: Any] = ["oldPassword": oldPass, "newPassword": newPass]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .addAdditionalEmergency(let name, let phoneNumber):
            let parameters: [String: Any] = ["name": name, "phoneNumber": phoneNumber]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .shareWithFriend(let email):
            let parameters: [String: Any] = ["email": email]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .deletePet(_), .deleteEmergency:
            return .requestPlain
        case .createMeetGreetService(let extraIds, let date):
            let parameters: [String: Any] = ["extraIds": extraIds, "date": date]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .createOrder(let list):
            let parameters: [String: Any] = list.convertToEditCustomerParameters()
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getHolidays(let dateFrom, let dateTo):
            let parameters: [String: Any] = ["dateFrom": dateFrom, "dateTo": dateTo]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getOrderDetails(mainOrderId: let orderId):
            let parameters: [String: Any] = ["mainOrderId": orderId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getUpcoming(date: let date, limit: let limit, page: let page):
            let parameters: [String: Any] = ["date": date, "limit": limit, "page": page]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getEmployeeProfile(employeeId: let employeeId,orderId: let order):
            let parameters: [String: Any] = ["employeeId" : employeeId,"orderId": order]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .getEmployeeDetail(employeeId: let employeeId, let order):
            let parameters: [String: Any] = ["employeeId" : employeeId,"orderId": order]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .rateEmployee(employeeId: _, orderId: let orderId, comment: let comment, rating: let rate):
            let parameters: [String: Any] = ["orderId": orderId, "comment": comment, "rating": rate]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getHistories(limit: let limit, page: let page):
            let parameters: [String: Any] = ["limit": limit, "page": page]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .cancel(order: let cancelOrder):
            let parameters: [String: Any] = cancelOrder.convertToParams()
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .takePetForOrder(let order):
            let parameters: [String: Any] = order.convertToParams()
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .cancelSingleVisit(order: let order):
            let parameters: [String: Any] = order.convertToParams()
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
            
        case .getProfile, .editProfile, .changePassword, .addAdditionalEmergency, .getProfileShort, .shareWithFriend, .deletePet, .getEmergencies, .deleteEmergency, .getStatusOfMeetNGreet,.getExtraMeetServiceDetail,.getServices, .getExtraServices, .createMeetGreetService, .createOrder, .getOrders, .getHolidays, .getOrderDetails, .getEmployeeDetail,.getUpcoming, .getUpcomingDetails, .getEmployeeProfile, .rateEmployee, .getHistories, .getHistoriesDetails, .cancelSingleVisit, .cancel, .takePetForOrder,.mapOrder,.mapOrderDetail:
            return .bearer
        }
    }
}
