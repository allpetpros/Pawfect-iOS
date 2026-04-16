//
//  AuthServices.swift
//  p103-customer
//
//  Created by Alex Lebedev on 15.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import Moya

class AuthService {
    
    // MARK: - Property
    let provider = MoyaProvider<AuthAPI>(plugins: [AccessTokenPlugin { _ in
        return DBManager.shared.getAccessToken() ?? ""
    }])
    let loginProvider = MoyaProvider<AuthAPI>(plugins: [AccessTokenPlugin { _ in
        return ""
    }])
    // MARK: - Functions

    
    func signUpMain(profile: RegistrationMainStruct, completion: @escaping (Result<RegistrationResponse, Error>) -> ()) {
        provider.request(.mainSignUp(registrationStruct: profile)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let token = try decoder.decode(RegistrationResponse.self, from: data)
                    
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
    
    func signUpStep(profile: RegistrationFile, completion: @escaping (Result<RegistrationStepResponse, Error>) -> ()) {
        provider.request(.signUpStep(registrationStep: profile)) { result in
            switch result {
                
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let token = try decoder.decode(RegistrationStepResponse.self, from: data)
                    
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
    
    func registration(blank: RegistrationBlank, completion: @escaping (Result<Response, Error>) -> ()) {
        provider.request(.addInfo(blank: blank)) { result in
            switch result {
                
            case .success(let s):
                completion(.success(s))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func uploadAvatar(image: UIImage, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.uploadAvatar(image: image)) { result in
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
    
    func signIn(profile: SignInRequest, completion: @escaping (Result<SignInResponce, Error>) -> ()) {
        print("Profile",profile)
        provider.request(.signIn(login: profile)) { result in
            
            switch result {
            
            case .success(let responce):
                print(responce)
                let data = responce.data
                let decoder = JSONDecoder()
                print(String(data: data, encoding: .utf8))
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let signInResponce = try decoder.decode(SignInResponce.self, from: data)
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
    
    func forgotPassword(email: String, completion: @escaping (Result<ForgotPasswordResponse, Error>) -> ()) {
        provider.request(.forgotPassword(email: email)) { result in
            switch result {
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let emailValid = try decoder.decode(ForgotPasswordResponse.self, from: data)
                        completion(.success(emailValid))
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
    
    func forgotPasswordComplite(code: String, newPass: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.forgotPasswordComplite(code: code, newPass: newPass)) { result in
            switch result {
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()

                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let responce = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(responce))
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
    func changePassword(oldPass: String, newPass: String, completion: @escaping (Result<SuccessResponse, Error>) -> ()) {
        provider.request(.changePassword(oldPass: oldPass, newPass: newPass)) { result in
            switch result {
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()

                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let responce = try decoder.decode(SuccessResponse.self, from: data)
                        completion(.success(responce))
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
    
    func checkZip(zip: String, completion: @escaping (Result<ZipResponse, Error>) -> ()) {
        provider.request(.checkZip(zipCode: zip)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let zipValid = try decoder.decode(ZipResponse.self, from: data)
                        completion(.success(zipValid))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func checkEmail(email: String, completion: @escaping (Result<ZipResponse, Error>) -> ()) {
        provider.request(.checkEmail(email: email)) { result in
            switch result {
            
            case .success(let responce):
                let data = responce.data
                let decoder = JSONDecoder()
                
                do {
                    let _ = try responce.filterSuccessfulStatusCodes()
                    do {
                        let zipValid = try decoder.decode(ZipResponse.self, from: data)
                        completion(.success(zipValid))
                    } catch {
                        completion(.failure(error))
                    }
                }
                catch  {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
