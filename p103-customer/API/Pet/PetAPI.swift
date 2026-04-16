//
//  PetAPI.swift
//  p103-customer
//
//  Created by Alex Lebedev on 23.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import Moya

enum PetAPI {
    case addPet(petParameters: [String: Any])
    case getAllPets(limit: Int, page: Int)
    case getFullProfilePet(id: String)
    case addSmallAnimal(body: SmallPet)
    case attachAvatar(id: String, image: UIImage)
    case editSmallPet(id: String, body: SmallPetEdit)
    case addCat(body: CatStructAdd)
    case getVaccination(id: String)
    case editCat(id: String, body: CatStruct)
    case addDog(body: DogStruct)
    case editDog(id: String, body: DogStructEdit)
    case deleteVaccination(idPet: String, idVaccination: String)
}

extension PetAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: Constant.baseURL)!
//        return URL(string: "http://bbeb-202-131-125-99.ngrok.io")!
//        return URL(string: "http://ec2-54-93-79-57.eu-central-1.compute.amazonaws.com")!
//        return URL(string: "http://dev1.spaceo.in/pawfect_web")!
    }

    var path: String {
        switch self {
        case .addPet:
            return "/employee/auth/sign-in"
        case .getAllPets:
            return "/customer/pets/all"
        case .getFullProfilePet(let id):
            return "/customer/pets/profile/\(id)"
        case .addSmallAnimal(_):
            return "/customer/pets/small-animal/"
        case .attachAvatar(let id, _):
            return "/customer/pets/\(id)/avatar"
        case .editSmallPet(let id, _):
            return "/customer/pets/small-animal/\(id)"
        case .addCat(_):
            return "/customer/pets/cat"
        case .getVaccination(let id):
            return "/customer/pets/\(id)/vaccinations"
        case .editCat(let id, _):
            return "/customer/pets/cat/\(id)"
        case .addDog(_):
            return "/customer/pets/dog"
        case .editDog(let id, _):
            return "/customer/pets/dog/\(id)"
        case .deleteVaccination(let idPet, let idVaccination):
            return "/customer/pets/\(idPet)/vaccinations/\(idVaccination)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addPet, .addSmallAnimal, .addCat, .addDog:
            return .put
        case .getAllPets, .getFullProfilePet, .getVaccination:
            return .get
        case .attachAvatar:
            return .post
        case .editSmallPet, .editCat, .editDog:
            return .patch
        case .deleteVaccination:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .addPet(let petParameters):
            return .requestParameters(parameters: petParameters, encoding: URLEncoding.default)
        case .getAllPets(let limit, let page):
            let parameters: [String: Any] = ["limit": limit, "page": page]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getFullProfilePet:
            return .requestPlain
        case .addSmallAnimal(body: let smallPet):
            let parameters: [String: Any] = smallPet.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .attachAvatar(id: _, let image):
            let imgData = image.jpegData(compressionQuality: 0.9) ?? Data()
            let a = MultipartFormData(provider: .data(imgData), name: "avatar", fileName: "avatar", mimeType: "image/png")
            return .uploadMultipart([a])
        case .editSmallPet(id: _, body: let smallPet):
            let parameters: [String: Any] = smallPet.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .addCat(body: let cat):
            let parameters: [String: Any] = cat.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getVaccination(id: _):
            return .requestPlain
        case .editCat(id: _, body: let cat):
            let parameters: [String: Any] = cat.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .addDog(body: let dog):
            let parameters: [String: Any] = dog.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .editDog(id: _, body: let dog):
            let parameters: [String: Any] = dog.convertToParameters()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .deleteVaccination:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        
        case .addPet, .getAllPets, .getFullProfilePet, .addSmallAnimal, .attachAvatar, .editSmallPet, .addCat, .getVaccination, .editCat, .addDog, .editDog, .deleteVaccination:
            return .bearer
        }
    }
}

