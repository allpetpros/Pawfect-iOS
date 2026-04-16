//
//  PaymentService.swift
//  p103-customer
//
//  Created by SOTSYS032 on 02/02/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import Foundation
import Moya

struct PaymentService {
    let provider = MoyaProvider<PaymentAPI>(plugins: [AccessTokenPlugin { _ in
        return DBManager.shared.getAccessToken() ?? ""
    }])
    
    func getAllCards(completion: @escaping (Result<GetCards, Error>) -> ()) {
        
        provider.request(.getCard) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let employee = try decoder.decode(GetCards.self, from: data)
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
    
    
    func addCard(profile: AddCard, completion: @escaping (Result<AddCardResponse, Error>) -> ()) {
        provider.request(.addCard(addCard: profile)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let token = try decoder.decode(AddCardResponse.self, from: data)
                    
                    completion(.success(token))
                } catch {
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
    
    
    func deleteCard(id: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.deleteCard(id: id)) { result in
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
    
    
    func addAmount(id: String, body: AddAmount, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.addAmount(id: id, addAmount: body)) { result in
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
    
    func getTransactionHistory(limit: Int, page: Int, completion: @escaping (Result<GetTransactionHistoryResponse, Error>) -> ()) {
        provider.request(.getHistoryDetails(limit: limit, page: page)) { result in
            switch result {
            
            case .success(let responce):
                
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let allPets = try decoder.decode(GetTransactionHistoryResponse.self, from: data)
                        
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
}
