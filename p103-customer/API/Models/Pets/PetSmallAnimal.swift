//
//  Pet.swift
//  p103-customer
//
//  Created by Yaroslav Laptiev on 9/26/19.
//  Copyright © 2019 PULS Software. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PetSmallAnimal {
    var name: String?
    var type: String?
    var imageURL: String?
    var gender: String?
    var breed: String?
    var medicalNotes: String?
    var veterinarianName: String?
    var veterinarianPhone: String?
    
    func convertToParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["name"] = name
        parameters["type"] = type
        parameters["gender"] = gender
        parameters["breed"] = breed
        parameters["image"] = imageURL
        parameters["veterinarianName"] = veterinarianName
        parameters["veterinarianPhone"] = veterinarianPhone
        return parameters
    }
    func fieldsValid() -> Bool {
        guard let name = self.name, !name.isEmpty,
            let breed = self.breed, !breed.isEmpty,
            let medicalNotes = self.medicalNotes, !medicalNotes.isEmpty,
            let veterinarianName = self.veterinarianName, !veterinarianName.isEmpty,
            let veterinarianPhone = self.veterinarianPhone, !veterinarianPhone.isEmpty else {
            return false
        }
        return true
    }
}
