//
//  PetDB.swift
//  p103-customer
//
//  Created by Alex Lebedev on 07.08.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import RealmSwift

class PetDB: Object {
    @objc dynamic var imageUrl: String? = nil
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var breed: String = ""
    @objc dynamic var gender: String = ""
    
    convenience init(pet: PetUniversal) {
        self.init()
        self.imageUrl = pet.imageUrl
        self.id = pet.id
        self.name = pet.name
        self.breed = pet.breed
        self.gender = pet.gender
    }
}
