//
//  Metadata.swift
//  p103-customer
//
//  Created by Alex Lebedev on 07.08.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation

struct Metadata: Codable {
    var totalItems: Int
    var itemCount: Int
    var itemsPerPage: Int
    var totalPages: Int
    var currentPage: Int
    
    enum MetadataCodingKey: String, CodingKey {
        case totalItems = "totalItems"
        case itemCount = "itemCount"
        case itemsPerPage = "itemsPerPage"
        case totalPages = "totalPages"
        case currentPage = "currentPage"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MetadataCodingKey.self)
        totalItems = try container.decode(Int.self, forKey: .totalItems)
        itemCount = try container.decode(Int.self, forKey: .itemCount)
        itemsPerPage = try container.decode(Int.self, forKey: .itemsPerPage)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        currentPage = try container.decode(Int.self, forKey: .currentPage)
    }
    
}
