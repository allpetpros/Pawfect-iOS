//
//  CalendarTimeOffStatus.swift
//  p103-customer
//
//  Created by Daria Pr on 01.06.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import Foundation

final class CalendarTimeOffStatus {
    static let shared = CalendarTimeOffStatus()
    
    var isClearCalendar = true
    var isClearSeparatedCalendar = true
    var isEdit = false
    
    var rangeStartedDate: Date?
    var rangeEndedDate: Date?
    
    var separatedSet = Set<Date>()
}
