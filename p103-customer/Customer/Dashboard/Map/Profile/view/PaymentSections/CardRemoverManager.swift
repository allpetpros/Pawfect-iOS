//
//  CardRemoverManager.swift
//  p103-customer
//
//  Created by Daria Pr on 02.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import Foundation

final class CardRemoverManager {
    static let shared = CardRemoverManager()
    
    var indexChoosen: Int = -1
    var isEmpty: Bool = false
    var isDelete: Bool = false
    var isAdd: Bool = false
    var isAmountAdded = false
    var isNoCard = false
}
