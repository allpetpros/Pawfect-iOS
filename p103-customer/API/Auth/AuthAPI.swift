//
//  AuthAPI.swift
//  p103-customer
//
//  Created by Alex Lebedev on 15.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import Moya

enum AuthAPI {

    case signUpStep(registrationStep: RegistrationFile)
    case mainSignUp(registrationStruct: RegistrationMainStruct)
    
    case addInfo(blank: RegistrationBlank)
    
    case forgotPassword(email: String)
    case forgotPasswordComplite(code: String, newPass: String)
    case changePassword(oldPass: String, newPass: String)
    
    case signIn(login: SignInRequest)
    
    case uploadAvatar(image: UIImage)
    
    case checkZip(zipCode: String)
    
    case checkEmail(email: String)
}

extension AuthAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: Constant.baseURL)!

    }

    var path: String {
        switch self {
        case .signUpStep:
            return "/auth/sign-up"
        case .addInfo:
            return "/customer/profile/add-info"
        case .signIn:
            return "/auth/sign-in"
        case .uploadAvatar:
            return "/customer/profile/avatar"
        case .forgotPassword:
            return "/auth/forgot-password"
        case .forgotPasswordComplite:
            return "/auth/forgot-password/change"
        case .changePassword:
            return "/customer/profile/password-change"
        case .checkZip:
            return "/auth/zip-code/check"
        case .checkEmail:
            return "/auth/email/check"
        case .mainSignUp:
            return "/auth/sign-up"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUpStep ,.signIn, .uploadAvatar, .forgotPasswordComplite, .changePassword:
            return .post
        case .addInfo:
            return .put
        case .forgotPassword, .checkZip, .checkEmail:
            return .get
        case .mainSignUp:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .signIn(login: let loginRequest):
            let parameters: [String: Any] = loginRequest.convertToParameters()
            print(parameters)
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .addInfo(let blank):
            let parameters: [String: Any] = blank.convertToAddInfoParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .uploadAvatar(let image):
            let imgData = image.jpegData(compressionQuality: 1.0) ?? Data()
            let a = MultipartFormData(provider: .data(imgData), name: "avatar", fileName: "avatar", mimeType: "image/png")
            return .uploadMultipart([a])
            
        case .forgotPassword(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.default)
            
        case .forgotPasswordComplite(code: let code, newPass: let newPass):
            let parameters: [String: Any] = ["code": code, "newPassword": newPass]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .changePassword(let oldPass, let newPass):
            let parameters: [String: Any] = ["oldPassword": oldPass, "newPassword": newPass]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        
        case .checkZip(zipCode: let zip):
            return .requestParameters(parameters: ["zipCode": zip], encoding: URLEncoding.default)
            
        case .checkEmail(email: let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.default)
            
        case .mainSignUp(registrationStruct: let registrationStruct):
            let parameters: [String: Any] = registrationStruct.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .signUpStep(registrationStep: let registrationStep):
            let parameters: [String: Any] = registrationStep.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .signUpStep, .signIn, .forgotPassword, .forgotPasswordComplite, .checkZip, .checkEmail, .mainSignUp:
            return nil
        case .addInfo, .uploadAvatar, .changePassword:
            return .bearer
        }
    }
}
