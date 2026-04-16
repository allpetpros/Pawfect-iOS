//
//  CustomerService.swift
//  p103-customer
//
//  Created by Alex Lebedev on 29.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import Moya

class CustomerService {

// MARK: - Property
let provider = MoyaProvider<CustomerAPI>(plugins: [AccessTokenPlugin { _ in
    
    return DBManager.shared.getAccessToken() ?? ""
}])
    
    func getEmergencies(completion: @escaping (Result<EmergenciesGetResponse, Error>) -> ()) {
        provider.request(.getEmergencies) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()

                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let customer = try decoder.decode(EmergenciesGetResponse.self, from: data)
                        completion(.success(customer))
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
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print(json)
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCurrentCustomer(completion: @escaping (Result<CustomerStruct, Error>) -> ()) {
        provider.request(.getProfile) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let customer = try decoder.decode(CustomerStruct.self, from: data)
                        completion(.success(customer))
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
    
    func getCustomerShort(completion: @escaping (Result<CustomerShort, Error>) -> ()) {
        provider.request(.getProfileShort) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print("Short Profile Result", String(data: data, encoding: .utf8))
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                         let customer = try decoder.decode(CustomerShort.self, from: data)
                         completion(.success(customer))
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
    
    func getStatusOfMeetNGreet(completion: @escaping (Result<MeetNGreetGetStatusResponse, Error>) -> ()) {
        provider.request(.getStatusOfMeetNGreet) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print("Short Profile Result", String(data: data, encoding: .utf8))
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                         let status = try decoder.decode(MeetNGreetGetStatusResponse.self, from: data)
                         completion(.success(status))
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
    
    func getDetailMeetNGreet(completion: @escaping (Result<MeetNGreetDetailResponse, Error>) -> ()) {
        provider.request(.getExtraMeetServiceDetail) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print("Short Profile Result", String(data: data, encoding: .utf8))
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let status = try decoder.decode(MeetNGreetDetailResponse.self, from: data)
                        completion(.success(status))
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

    func createMeetNGreetOrder(extrasIds: String, date: Int,completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.createMeetGreetService(extraIds: extrasIds, date: date)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let response = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(response))
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
    
    func changePassword(oldPass: String, newPass: String, confirmNewPass: String, completion: @escaping (Result<Customer, Error>) -> ()) {
        provider.request(.changePassword(oldPass: oldPass, newPass: newPass)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let customer = try decoder.decode(Customer.self, from: data)
                        completion(.success(customer))
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
    
    func shareWithFriends(email: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.shareWithFriend(email: email)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let customer = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(customer))
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
    
    func editCustomerAccount(blank: ProfileStruct, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.editProfile(blank)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print(String(data: data, encoding: .utf8))
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let customer = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(customer))
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
    
    func addEmergencies(name: String, phoneNumber: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.addAdditionalEmergency(name: name, phoneNumber: phoneNumber)) { result in
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
    
    func deletePet(id: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.deletePet(petId: id)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                         let customer = try decoder.decode(SuccessResponse.self, from: data)
                         completion(.success(customer))
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
    
    func deleteEmergencies(id: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.deleteEmergency(id: id)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                         let customer = try decoder.decode(SuccessResponse.self, from: data)
                         completion(.success(customer))
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
    
    func getServices(completion: @escaping (Result<ServicesGetResponse, Error>) -> ()) {
        provider.request(.getServices) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                
                let decoder = JSONDecoder()

                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                         let customer = try decoder.decode(ServicesGetResponse.self, from: data)
                         completion(.success(customer))
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
    
    func getExtras(completion: @escaping (Result<ExtrasResponse, Error>) -> ()) {
        provider.request(.getExtraServices) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()

                
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                         let customer = try decoder.decode(ExtrasResponse.self, from: data)
                         completion(.success(customer))
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
    
    func addOrder(list: CreatingOrder, completion: @escaping (Result<Order, Error>) -> ()) {
        provider.request(.createOrder(list: list)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let customer = try decoder.decode(Order.self, from: data)
                        completion(.success(customer))
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
    
    func getOrders(limit: Int, page: Int, completion: @escaping (Result<OrdersResponse, Error>) -> ()) {
        
        provider.request(.getOrders(limit: limit, page: page)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print("Get Orders",String(data: data, encoding: .utf8))
                
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                         let customer = try decoder.decode(OrdersResponse.self, from: data)
                         
                         for order in customer.items {
                             
                             for (j,item) in order.orders.enumerated() {
//                                 var objItem = item
                                  item.updateVisit(visit: order.visits[j % order.visits.count])
//                                 objItem.visit = order.visits[j % order.visits.count]
//                                 j.updateVisit(visit: order.visits[0])
                             }
                         }
                         completion(.success(customer))
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
    
    func getDetailsOrder(id: String, completion: @escaping (Result<OrderDetails, Error>) -> ()) {
        provider.request(.getOrderDetails(mainOrderId: id)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                         let customer = try decoder.decode(OrderDetails.self, from: data)
                         completion(.success(customer))
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
    
    func getUpcomingOrder(date: Int, limit: Int, page: Int, completion: @escaping (Result<UpcomingResponse, Error>) -> ()) {
        
        provider.request(.getUpcoming(date: date, limit: limit, page: page)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                let d = String(data: data, encoding: .utf8)
                print("Upcoming Response ",d)
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                        let allPets = try decoder.decode(UpcomingResponse.self, from: data)

                         completion(.success(allPets))
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
    
    func getUpcomingOrderDetails(id: String, completion: @escaping (Result<UpcomingDetailsOrder, Error>) -> ()) {
        provider.request(.getUpcomingDetails(id: id)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print("Upcoming Order Details:\(String(data: data, encoding: .utf8))")
                
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                        let allPets = try decoder.decode(UpcomingDetailsOrder.self, from: data)

                         completion(.success(allPets))
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
    
    func getHoliday(dateFrom: String, dateTo: String, completion: @escaping (Result<Holidays, Error>) -> ()) {
        provider.request(.getHolidays(dateFrom: dateFrom, dateTo: dateTo)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                        let allPets = try decoder.decode(Holidays.self, from: data)

                         completion(.success(allPets))
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
    
    func getEmployeeProfile(employeeId: String, orderId: String, completion: @escaping (Result<EmployeeProfile, Error>) -> ()) {
        provider.request(.getEmployeeProfile(employeeId: employeeId, orderId: orderId)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                        let allPets = try decoder.decode(EmployeeProfile.self, from: data)

                         completion(.success(allPets))
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
    
    func getEmployeeDetails(employeeId: String, orderId: String, completion: @escaping (Result<EmployeeProfile, Error>) -> ()) {
        
        provider.request(.getEmployeeDetail(employeeId: employeeId, orderId: orderId)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                        let allPets = try decoder.decode(EmployeeProfile.self, from: data)

                         completion(.success(allPets))
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
    
    func rateEmployee(emplId: String, orderId: String, comment: String?, rate: Double, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.rateEmployee(employeeId: emplId, orderId: orderId, comment: comment, rating: rate)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print(String(data: data, encoding: .utf8))
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let customer = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(customer))
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
    
    func getHistories(limit: Int, page: Int, completion: @escaping (Result<HistoriesResponse, Error>) -> ()) {
        provider.request(.getHistories(limit: limit, page: page)) { result in
            switch result {

            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print("Histories data is \(String(data: data, encoding: .utf8))")
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                        let allPets = try decoder.decode(HistoriesResponse.self, from: data)

                         completion(.success(allPets))
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
    
    func getHistoriesDetails(ordersId: String, completion: @escaping (Result<HistoriesDetails, Error>) -> ()) {
        provider.request(.getHistoriesDetails(id: ordersId)) { result in
            switch result {

            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print(String(data: data, encoding: .utf8))
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                        let allPets = try decoder.decode(HistoriesDetails.self, from: data)

                         completion(.success(allPets))
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
    
    func cancel(order: CancelOrder, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.cancel(order: order)) { result in
            switch result {

            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                        let allPets = try decoder.decode(SuccessResponse.self, from: data)

                         completion(.success(allPets))
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
    
    func cancelSingleOrder(order: CancelOrder, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.cancelSingleVisit(order: order)) { result in
            switch result {

            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                        let allPets = try decoder.decode(SuccessResponse.self, from: data)

                         completion(.success(allPets))
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
    
    func takePetForOrder(order: PetForOrder, completion: @escaping (Result<PetOrdersStruct, Error>) -> ()) {
        provider.request(.takePetForOrder(order: order)) { result in
            switch result {

            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                        let allPets = try decoder.decode(PetOrdersStruct.self, from: data)

                         completion(.success(allPets))
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
    
    func getMapOrders(completion: @escaping (Result<CustomerMapResponse, Error>) -> ()) {
        provider.request(.mapOrder) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()

                
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                         let customer = try decoder.decode(CustomerMapResponse.self, from: data)
                         completion(.success(customer))
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
    
    func getMapOrderDetail(id: String, completion: @escaping (Result<CustomerMapDetailResponse, Error>) -> ()) {
        provider.request(.mapOrderDetail(id: id)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()

                
                   do {
                     let _ = try responce.filterSuccessfulStatusCodes()
                     do {
                         let customer = try decoder.decode(CustomerMapDetailResponse.self, from: data)
                         completion(.success(customer))
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
