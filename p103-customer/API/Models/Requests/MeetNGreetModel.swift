//
//  MeetNGreetModel.swift
//  p103-customer
//
//  Created by Foram Mehta on 04/05/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import Foundation
// Employee Side MeetNGreet
struct GetListOfMeetNGreet: Codable {
    let items: [MeetNGreetItem]
    let meta: Meta
}

// Item
struct MeetNGreetItem: Codable {
    let id, status: String
    let timeFrom: Int
    let customer: CustomerDetail
    let extra: Extra
}

// Customer
struct CustomerDetail: Codable {
    let id, name, surname, phoneNumber: String
    let imageURL: String?
    let address, zipCode: String

    enum CodingKeys: String, CodingKey {
        case id, name, surname, phoneNumber
        case imageURL = "imageUrl"
        case address, zipCode
    }
}

// Extra
struct Extra: Codable {
    let id, title, extraDescription: String
    let price: Int

    enum CodingKeys: String, CodingKey {
        case id, title
        case extraDescription = "description"
        case price
    }
}



