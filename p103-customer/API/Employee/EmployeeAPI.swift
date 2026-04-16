//
//  EmployeeAPI.swift
//  p103-customer
//
//  Created by Alex Lebedev on 29.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import Moya
import SwiftUI

enum EmployeeAPI {
    case getProfile
    case getTimeOffs
    case addTimeOffs(form: TimeOffsAdding)
    case editTimeOff(id: String, form: TimeOffsAdding)
    case getTotalCredits
    case getAppointmentHistory
    
    case getRating
    case getTotalRating
    case getNewOrders(limit: Int, page: Int)
    case getNewOrderDetail(id: String)
    case acceptOrder(id: String)
    case cancelOrder(id: String)
    case getConfirmedOrder(date: Int, limit: Int, page: Int)
    case getConfirmedDetails(id: String)
    case getHistories(limit: Int, page: Int)
    case getHistoryDetails(id: String)
    case getCurrentMapOrders
    case getCurrentMapOrderDetails(id: String)
    case nextStepMap(id: String)
    case saveMapTime(id: String, orderCheckId: String, minutes: Int)
    case attachPhoto(id: String, orderCheckId: String, attachment: UIImage)
    case saveMapPosition(id: String, positions: MapPosition)
    case savePetAction(id: String,orderCheckId: String,name: String,lat: Double,long:Double,createdAt: Int64)
    case finishMapOrder(orderId: String, positions: MapPosition)
    case getPetProfile(id: String)
    case getCustomerProfile(id: String)
    case getListOfMeetNGreetRequest
    case acceptMeetNGreetOrder(id: String)
    case cancelMeetNGreetOrder(id: String)
    case completeMeetNGreetOrder(id: String)
    case sendOrderSummary(id: String)
}

extension EmployeeAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: Constant.baseURL)!

    }
    
    var path: String {
        switch self {
            
        case .getProfile:
            return "/employee/profiles/my"
        case .getTimeOffs, .addTimeOffs:
            return "/employee/time-offs"
        case .getTotalCredits:
            return "/employee/payrolls/my/total"
        case .editTimeOff(let id, _):
            return "/employee/time-offs/\(id)"
        case .getRating:
            return "/employee/ratings/my"
        case .getAppointmentHistory:
            return "/employee/payrolls/my"
        case .getTotalRating:
            return "/employee/ratings/my/total"
        case .getNewOrders:
            return "/employee/new-orders"
        case .getNewOrderDetail(let id):
            return "/employee/new-orders/\(id)"
        case .acceptOrder(let id):
            return "/employee/new-orders/\(id)/accept"
        case .cancelOrder(let id):
            return "/employee/new-orders/\(id)/cancel"
        case .getConfirmedOrder:
            return "/employee/confirmed"
        case .getConfirmedDetails(let id):
            return "/employee/confirmed/\(id)"
        case .getHistories:
            return "/employee/histories/my"
        case .getHistoryDetails(let id):
            return "/employee/histories/\(id)"
        case .getCurrentMapOrders:
            return "/employee/map/"
        case .getCurrentMapOrderDetails(let id):
            return "/employee/map/\(id)"
        case .nextStepMap(let id):
            return "/employee/map/\(id)/next"
        case .saveMapTime(let id, _, _):
            return "/employee/map/\(id)/time"
        case .attachPhoto(let id, _, _):
            return "/employee/map/\(id)/attachment"
        case .saveMapPosition(let id, _):
            return "/employee/map/\(id)/position"
        case .finishMapOrder(let orderId,_):
            return "/employee/map/\(orderId)/finish"
            
        case .savePetAction(let id, _, _, _, _, _):
            return "employee/map/\(id)/action"
        case .getPetProfile(let id):
            return "/employee/pets/\(id)"
        case .getCustomerProfile(let id):
            return "/employee/customers/\(id)"
        case .getListOfMeetNGreetRequest:
            return "/employee/first-orders"
        case .acceptMeetNGreetOrder(let id):
            return "/employee/first-orders/\(id)/accept"
        case .cancelMeetNGreetOrder(let id):
            return "/employee/first-orders/\(id)/cancel"
        case .completeMeetNGreetOrder(let id):
            return "/employee/first-orders/\(id)/finished"
            
        case .sendOrderSummary(let id):
            return "employee/map/\(id)/mail"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getProfile, .getTimeOffs, .getRating, .getTotalRating,.getTotalCredits ,.getAppointmentHistory,.getNewOrders, .getNewOrderDetail, .getConfirmedOrder, .getConfirmedDetails, .getHistoryDetails, .getHistories, .getCurrentMapOrders, .getCurrentMapOrderDetails, .getPetProfile, .getCustomerProfile, .getListOfMeetNGreetRequest,.sendOrderSummary:
            return .get
        case .addTimeOffs:
            return .put
        case .editTimeOff:
            return .patch
        case .acceptOrder, .cancelOrder, .nextStepMap, .saveMapTime, .attachPhoto, .saveMapPosition, .finishMapOrder,.cancelMeetNGreetOrder,.acceptMeetNGreetOrder,.completeMeetNGreetOrder,.savePetAction:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        
        case .getProfile, .getTotalRating,.getTotalCredits,.getAppointmentHistory,.getCurrentMapOrders, .getCurrentMapOrderDetails, .getPetProfile, .getCustomerProfile,.getListOfMeetNGreetRequest:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getTimeOffs, .getRating, .getNewOrderDetail, .getConfirmedDetails, .getHistories, .getHistoryDetails:
            return .requestPlain
        case .getNewOrders(let limit, let page):
            let parameters: [String: Any] = ["limit": limit, "page": page]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .addTimeOffs(let form):
            let parameters: [String: Any] = form.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .editTimeOff(_, let form):
            let parameters: [String: Any] = form.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .acceptOrder(let id):
            let parameters: [String: Any] = ["orderId": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .cancelOrder(let id):
            let parameters: [String: Any] = ["orderId": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getConfirmedOrder(let date, let limit, let page):
            let parameters: [String: Any] = ["date": date, "limit": limit, "page": page]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .nextStepMap:
            return .requestPlain
        case .saveMapTime(_, let orderCheckId, let minutes):
            let parameters: [String: Any] = ["orderCheckId": orderCheckId, "minutes": minutes]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .savePetAction(_, let orderCheckId, let name, let lat, let long, let createdAt):
            let parameters: [String: Any] = ["orderCheckId": orderCheckId, "name": name, "lat": lat, "long":long, "createdAt":createdAt]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .attachPhoto(_, let orderCheckId, let attachment):
            let parameters: [String: Any] = ["orderCheckId": orderCheckId, "attachment": attachment]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .saveMapPosition(_, let positions):
            let parameters: [String: Any] = ["positions": positions]
            do{
                let dic = try positions.dictionary()
                return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
            }
            catch {
                return .requestParameters(parameters:parameters, encoding: URLEncoding.default)
            }
        
        case .finishMapOrder(_, let positions):
            let parameters: [String: Any] = ["positions": positions]
            do{
                let dic = try positions.dictionary()
                return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
            }
            catch {
                return .requestParameters(parameters:parameters, encoding: URLEncoding.default)
            }
            
        case .acceptMeetNGreetOrder(let id):
            let parameters: [String: Any] = ["orderId": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
            
        case .cancelMeetNGreetOrder(let id):
            let parameters: [String: Any] = ["orderId": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .completeMeetNGreetOrder(let id):
            let parameters: [String: Any] = ["orderId": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .sendOrderSummary(let id):
            let parameters: [String: Any] = ["orderId": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
                
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
            
        case .getProfile, .getTimeOffs, .addTimeOffs, .editTimeOff, .getTotalCredits,.getAppointmentHistory,.getRating, .getTotalRating, .getNewOrders, .getNewOrderDetail, .acceptOrder, .cancelOrder, .getConfirmedOrder, .getConfirmedDetails, .getHistories, .getHistoryDetails, .getCurrentMapOrders, .getCurrentMapOrderDetails, .nextStepMap, .saveMapTime, .attachPhoto, .saveMapPosition, .finishMapOrder, .getPetProfile,.savePetAction, .getCustomerProfile,.getListOfMeetNGreetRequest,.acceptMeetNGreetOrder,.cancelMeetNGreetOrder,.completeMeetNGreetOrder,.sendOrderSummary:
            return .bearer
        }
    }
}
