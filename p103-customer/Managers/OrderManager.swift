//
//  OrderManager.swift
//  p103-customer
//
//  Created by Daria Pr on 25.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

final class OrderManager {
    static let shared = OrderManager()
    
    var serviceId = ""
    var petIds = Set<String>()
    var dates = [Int64]()
    var separatedDates = Set<Date>()
    var copySeparatedDates = Set<Date>()
    var startedDate: Date?
    var endedDate: Date?
    var partOfDays = Set<String>()
    var visits = [String: String]()
    var extraIds = Set<String>()
    var extraTitle = ""
    var extraTitleArr = [String]()
    var extraPrice = [Int]()
    var totalExtraPrice = Int()
    var price = 0
    var nameOfPet = [String]()
    var imageOfPet = [String]()
    var service = ""
    var serviceImage = ""
    var visitCount: Int32?
    var typeOfCalendar = ""
    var type = ""
    var copyStart: Date?
    var copyEnd: Date?
    var morningHours = String()
    var afternoonHours = String()
    var eveningHours = String()
    var totalTime = String()
    var calendarDayDate = Date()
}
