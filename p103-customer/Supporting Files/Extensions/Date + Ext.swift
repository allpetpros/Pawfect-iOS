//
//  Date + Ext.swift
//  u92
//
//  Created by Developer on 4/11/19.
//  Copyright © 2019 Anastasia Zhdanova. All rights reserved.
//
// swiftlint:disable all


import Foundation

extension Date {
    
    var millisecondsSince1970: Int64 {
        print(self.timeIntervalSince1970)
        return Int64((self.timeIntervalSince1970 * 1000.0))
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    /// Date string from date.
    ///
    ///     Date().string(withFormat: "dd/MM/yyyy") -> "1/12/17"
    ///     Date().string(withFormat: "HH:mm") -> "23:50"
    ///     Date().string(withFormat: "dd/MM/yyyy HH:mm") -> "1/12/17 23:50"
    ///
    /// - Parameter format: Date format (default is "dd/MM/yyyy").
    /// - Returns: date string.
    func string(withFormat format: String = "MM/dd/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    /// Date string from date.
    ///
    ///     Date().dateString(ofStyle: .short) -> "1/12/17"
    ///     Date().dateString(ofStyle: .medium) -> "Jan 12, 2017"
    ///     Date().dateString(ofStyle: .long) -> "January 12, 2017"
    ///     Date().dateString(ofStyle: .full) -> "Thursday, January 12, 2017"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date string.
    func dateString(ofStyle style: DateFormatter.Style = .short) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    /// Time string from date
    ///
    ///     Date().timeString(ofStyle: .short) -> "7:37 PM"
    ///     Date().timeString(ofStyle: .medium) -> "7:37:02 PM"
    ///     Date().timeString(ofStyle: .long) -> "7:37:02 PM GMT+3"
    ///     Date().timeString(ofStyle: .full) -> "7:37:02 PM GMT+03:00"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: time string.
    func timeString(ofStyle style: DateFormatter.Style = .short) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }
    
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
    func createTimeRange(_ to: Date, interval min: Int) -> [Date] {
        let interval = TimeInterval(60*min)
        guard interval > 0 else { return [] }
        var dates:[Date] = []
        var currentDate = self
        
        while currentDate < to {
            currentDate = currentDate.addingTimeInterval(interval)
            dates.append(currentDate)
        }
        return dates
    }
    
    func getDate(_ dateStyle: DateFormatter.Style, _ timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: self)
    }
    
    func getDayMMM() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter.string(from: self)
    }
    
    func getDayMMMM() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(from: self)
    }
    
    func getDayWeekDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "d EEEE"
        return dateFormatter.string(from: self)
    }
    
    func getWeekDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Calendar.current.timeZone
        return calendar
    }
    
    private static let weekdayAndDateStampDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEE, MMM dd yyyy" // "Monday, Mar 7 2016"
        return dateFormatter
    }()
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self) + TimeInterval(TimeZone.current.secondsFromGMT())
    }
    
    var startDateOfMonth: Date? {
        let components = calendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: self)
        return calendar.date(from: components)?.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
    }
    
    var dateInYears: Int? {
        let components =
            Calendar.current.dateComponents(Set<Calendar.Component>([.year]), from: self)
        return components.year
    }
    
    var endDateOfMonth: Date? {
        guard let startOfMonth = self.startDateOfMonth else { return nil }
        guard let dayCountInMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count else { return nil }
        
        return calendar.date(byAdding: .day, value: dayCountInMonth - 1, to: startOfMonth)
    }
    
    func toWeekDayAndDateString() -> String {
        return Date.weekdayAndDateStampDateFormatter.string(from: self)
    }
    
    func toString(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getDateDifferenceInStringByGreatestComponent(for date: Date = Date(), with components: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second]) -> String {
        let dateDifferenceComponents =
            Calendar.current.dateComponents(Set<Calendar.Component>(components), from: self, to: date)
        var componentInString = ""
        var dateComponent = 0
        if let years = dateDifferenceComponents.year, years > 0 {
            componentInString = "\(years) Year"
            dateComponent = years
        } else if let months = dateDifferenceComponents.month, months > 0 {
            componentInString = "\(months) Month"
            dateComponent = months
        } else if let days = dateDifferenceComponents.day, days > 0 {
            componentInString = "\(days) Day"
            dateComponent = days
        } else if let hours = dateDifferenceComponents.hour, hours > 0 {
            componentInString = "\(hours) Hour"
            dateComponent = hours
        } else if let minutes = dateDifferenceComponents.minute, minutes > 0 {
            componentInString = "\(minutes) Minute"
            dateComponent = minutes
        } else if let seconds = dateDifferenceComponents.second {
            componentInString = "\(seconds) Second"
            dateComponent = seconds
        }
        
        if dateComponent > 1 {
            componentInString += "s"
        }
        
        return componentInString
    }
    
    func date(byAdding component: Calendar.Component, _ value: Int) -> Date? {
        calendar.date(byAdding: component, value: value, to: self)
    }
    
    func isDayEquals(to date: Date?) -> Bool {
        guard let date = date else { return false }
        let comparisonResult = calendar.compare(self, to: date, toGranularity: .day)
        
        return comparisonResult == .orderedSame
    }
    
    func isDayEqualsOrGreater(to date: Date?) -> Bool {
        guard let date = date else { return false }
        let comparisonResult = calendar.compare(self, to: date, toGranularity: .day)
        
        switch comparisonResult {
        case .orderedDescending, .orderedSame: return true
        default: return false
        }
    }
    
    func isDayEqualsOrLess(to date: Date?) -> Bool {
        guard let date = date else { return false }
        let comparisonResult = calendar.compare(self, to: date, toGranularity: .day)
        
        switch comparisonResult {
        case .orderedAscending, .orderedSame: return true
        default: return false
        }
    }
    
    func isMonthEquals(to date: Date) -> Bool {
        let comparisonResult = calendar.compare(self, to: date, toGranularity: .month)
        
        return comparisonResult == .orderedSame
    }
    
    func weekdayNumberOfDay() -> Int {
        (calendar.component(.weekday, from: self) - 2 + 7) % 7 + 1
    }
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    var firstDayOfTheMonth: Date {
        Calendar.current.dateComponents([.calendar, .year,.month], from: self).date!
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}
