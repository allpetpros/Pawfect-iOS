//
//  EmployeeService.swift
//  p103-customer
//
//  Created by Alex Lebedev on 13.08.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import Moya

class EmployeeService {
    
    // MARK: - Property
    let provider = MoyaProvider<EmployeeAPI>(plugins: [AccessTokenPlugin { _ in
        
        return DBManager.shared.getAccessToken() ?? ""
    }])
    func getCurrentEmployee(completion: @escaping (Result<EmployeeGet, Error>) -> ()) {
        provider.request(.getProfile) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(EmployeeGet.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTimeOff(completion: @escaping (Result<TimeOffs, Error>) -> ()) {
        provider.request(.getTimeOffs) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(TimeOffs.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addTimeOff(form: TimeOffsAdding, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.addTimeOffs(form: form)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let signInResponce = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(signInResponce))
                    } catch {
                        completion(.failure(error))
                    }
                }
                
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func editTimeOff(id: String, form: TimeOffsAdding, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.editTimeOff(id: id, form: form)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let signInResponce = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(signInResponce))
                    } catch {
                        completion(.failure(error))
                    }
                }
                
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRating(completion: @escaping (Result<Rating, Error>) -> ()) {
        provider.request(.getRating) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()

                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(Rating.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNewOrders(limit: Int, page: Int, completion: @escaping (Result<EmployeeOrders, Error>) -> ()) {
        provider.request(.getNewOrders(limit: limit, page: page)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(EmployeeOrders.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNewOrderDetail(id: String, completion: @escaping (Result<EmployeeDetails, Error>) -> ()) {
        provider.request(.getNewOrderDetail(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(EmployeeDetails.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func acceptNewOrder(id: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.acceptOrder(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func acceptNewMeetNGreetOrder(id: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.acceptMeetNGreetOrder(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelOrder(id: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.cancelOrder(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelMeetNGreetOrder(id: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.cancelMeetNGreetOrder(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func completeMeetNGreetOrder(id: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.completeMeetNGreetOrder(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getConfirmed(date: Int, limit: Int, page: Int, completion: @escaping (Result<EmployeeConfirmedOrders, Error>) -> ()) {
        provider.request(.getConfirmedOrder(date: date, limit: limit, page: page)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print(String(data: data, encoding: .utf8) as Any)
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(EmployeeConfirmedOrders.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getConfirmedDetails(id: String, completion: @escaping (Result<EmployeeDetailsConfirmed, Error>) -> ()) {
        provider.request(.getConfirmedDetails(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(EmployeeDetailsConfirmed.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getHistories(limit: Int, page: Int, completion: @escaping (Result<EmployeeHistoryOrders, Error>) -> ()) {
        provider.request(.getHistories(limit: limit, page: page)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(EmployeeHistoryOrders.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

    
    func getHistoryDetails(id: String, completion: @escaping (Result<HistoryDetailsOrder, Error>) -> ()) {
        provider.request(.getHistoryDetails(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(HistoryDetailsOrder.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCurrentMapOrders(completion: @escaping (Result<CurrentOrdersMap, Error>) -> ()) {
        provider.request(.getCurrentMapOrders) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(CurrentOrdersMap.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCurrentMapOrderDetails(id: String, completion: @escaping (Result<CurrentOrderMapDetails, Error>) -> ()) {
        provider.request(.getCurrentMapOrderDetails(id: id)) { result in
            switch result {
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print("Map Order Detail\(String(data: data, encoding: .utf8))")
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(CurrentOrderMapDetails.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveMapTime(id: String, orderCheckId: String, minutes: Int, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        
        provider.request(.saveMapTime(id: id, orderCheckId: orderCheckId, minutes: minutes)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func savePetAction(id: String, orderCheckId: String,name: String, lat: Double,long: Double,createdAt: Int64, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.savePetAction(id: id, orderCheckId: orderCheckId, name: name, lat: lat, long: long, createdAt: createdAt)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func attachMapPhoto(id: String, orderCheckId: String, attachment: UIImage, completion: @escaping (Result<URLResponse, Error>) -> ()) {
        provider.request(.attachPhoto(id: id, orderCheckId: orderCheckId, attachment: attachment)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(URLResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveMapPosition(id: String, positions: MapPosition, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {

        provider.request(.saveMapPosition(id: id, positions: positions)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func finishMapOrder(id: String,positions: MapPosition, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.finishMapOrder(orderId: id, positions: positions)) { result in
            switch result {
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPetProfile(id: String, completion: @escaping (Result<PetStruct, Error>) -> ()) {
        provider.request(.getPetProfile(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(PetStruct.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCustomerProfile(id: String, completion: @escaping (Result<CustomerProfile, Error>) -> ()) {
        provider.request(.getCustomerProfile(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(CustomerProfile.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTotalCredit(completion: @escaping (Result<TotalAmountCreditResponse, Error>) -> ()) {
        provider.request(.getTotalCredits) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(TotalAmountCreditResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAppointmentHistory(completion: @escaping (Result<AppointmentHistory, Error>) -> ()) {
        provider.request(.getAppointmentHistory) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(AppointmentHistory.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getListOfMeetNGreetRequest(completion: @escaping (Result<GetListOfMeetNGreet, Error>) -> ()) {
        provider.request(.getListOfMeetNGreetRequest) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(GetListOfMeetNGreet.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func nextStepMap(id: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.nextStepMap(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(employee))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func sendOrderSummary(id: String,completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.sendOrderSummary(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let signInResponce = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(signInResponce))
                    } catch {
                        completion(.failure(error))
                    }
                }
                
                catch  {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
