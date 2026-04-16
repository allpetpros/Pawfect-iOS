//
//  PetService.swift
//  p103-customer
//
//  Created by Alex Lebedev on 23.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import Moya

class PetService {
    
    // MARK: - Property
    let provider = MoyaProvider<PetAPI>(plugins: [AccessTokenPlugin {_ in 
        
        return DBManager.shared.getAccessToken() ?? ""
    }])
    
    var activityView: UIActivityIndicatorView?
    
    // MARK: - Functions
    
    func getAllPets(limit: Int, page: Int, completion: @escaping (Result<TestStruct, Error>) -> ()) {
        provider.request(.getAllPets(limit: limit, page: page)) { result in
            switch result {
            
            case .success(let responce):
                
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let allPets = try decoder.decode(TestStruct.self, from: data)
                        
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
    
    func getFullProfilePet(id: String, completion: @escaping (Result<PetsProfile, Error>) -> ()) {
        provider.request(.getFullProfilePet(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let allPets = try decoder.decode(PetsProfile.self, from: data)
                        
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
    
    func getDogProfile(id: String, completion: @escaping (Result<DogStructGet, Error>) -> ()) {
        provider.request(.getFullProfilePet(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print(String(data: data, encoding: .utf8) as Any)
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let allPets = try decoder.decode(DogStructGet.self, from: data)
                        
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
    
    func getCatProfile(id: String, completion: @escaping (Result<CatStructGet, Error>) -> ()) {
        provider.request(.getFullProfilePet(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print(String(data: data, encoding: .utf8) as Any)
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let allPets = try decoder.decode(CatStructGet.self, from: data)
                        print(allPets)
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
    
    
    func getSmallAnimalProfile(id: String, completion: @escaping (Result<SmallPetGet, Error>) -> ()) {
        provider.request(.getFullProfilePet(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                print(String(data: data, encoding: .utf8) as Any)
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let allPets = try decoder.decode(SmallPetGet.self, from: data)
                        
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
    
    func addSmallAnimal(body: SmallPet, completion: @escaping (Result<AddAnimalResponse, Error>) -> ()) {
        provider.request(.addSmallAnimal(body: body)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let signInResponce = try decoder.decode(AddAnimalResponse.self, from: data)
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
    
    func addCat(body: CatStructAdd, completion: @escaping (Result<AddAnimalResponse, Error>) -> ()) {
        
        provider.request(.addCat(body: body)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let signInResponce = try decoder.decode(AddAnimalResponse.self, from: data)
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
    
    func editSmallAnimal(id: String, body: SmallPetEdit, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.editSmallPet(id: id, body: body)) { result in
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
    
    
    func attachAvatar(id: String, image: UIImage, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.attachAvatar(id: id, image: image)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let responce = try decoder.decode(SuccessResponse.self, from: data)
                    completion(.success(responce))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getVaccinePhoto(id: String, completion: @escaping (Result<Vaccine, Error>) -> ()) {
        provider.request(.getVaccination(id: id)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let allPets = try decoder.decode(Vaccine.self, from: data)
                        
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
    
    func editCat(id: String, body: CatStruct, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.editCat(id: id, body: body)) { result in
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
    
    func addDog(body: DogStruct, completion: @escaping (Result<AddAnimalResponse, Error>) -> ()) {
        provider.request(.addDog(body: body)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let signInResponce = try decoder.decode(AddAnimalResponse.self, from: data)
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
    
    func editDog(id: String, body: DogStructEdit, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.editDog(id: id, body: body)) { result in
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
    
    func deleteVaccination(petId: String, vaccinationId: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.deleteVaccination(idPet: petId, idVaccination: vaccinationId)) { result in
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
