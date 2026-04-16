import Foundation
import Moya

enum PaymentAPI {
    case getCard
    case addCard(addCard: AddCard)
    case deleteCard(id: String)
    case addAmount(id: String, addAmount: AddAmount)
    case getHistoryDetails(limit: Int, page: Int)
//    case removeCars(id:String)
}

extension PaymentAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: Constant.baseURL)!

    }

    var path: String {
        
        switch self {
        case .getCard:
            return "/customer/payment/card/all"
        case .addCard:
            return "/customer/payment/card"
        case .deleteCard(let id):
            return "/customer/payment/card/\(id)"
        case .addAmount(let id, _):
            return "/customer/payment/card/amount/\(id)"
        case .getHistoryDetails:
            return "/customer/payment/history"
//
        }
        
    }
    
    var method: Moya.Method {
        
        switch self {
        case .getCard, .getHistoryDetails:
            return .get
        case .addCard,.addAmount:
            return .put
        case .deleteCard:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    
    var task: Task{
        switch self {
            
        case .getCard:
            let parameters: [String: Any] = [:]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .addCard(addCard: let addCard):
            let parameters: [String: Any] = addCard.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .deleteCard(_):
            return .requestPlain
        case .addAmount(id: _, addAmount: let addAmount):
            let parameters: [String: Any] = addAmount.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getHistoryDetails(let limit, let page):
            let parameters: [String: Any] = ["limit": limit, "page": page]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        
        case .getCard,.addCard,.deleteCard,.addAmount,.getHistoryDetails:
            return .bearer
        
    }
    }
}
