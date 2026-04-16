//
//  CalendarUpdateManager.swift
//  p103-customer
//
//  Created by Daria Pr on 11.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import Foundation

final class CalendarUpdateManager {
    static let shared = CalendarUpdateManager()
    
    var startDate = Date()
    var endDate = Date()
}
