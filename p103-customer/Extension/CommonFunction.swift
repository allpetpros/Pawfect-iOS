//
//  Static File.swift
//  p103-customer
//
//  Created by Foram Mehta on 25/02/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import Foundation

//MARK: - Convert 24 hours format to 12 Hours

class CommonFunction {
    
    static let shared = CommonFunction()
    
    func convertTimeTOHoursFormat(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let date = dateFormatter.date(from: time)
        dateFormatter.dateFormat = "hh:mm a"
        let Date12 = dateFormatter.string(from: date ?? Date())
        print("12 hour formatted Date:",Date12)
        return Date12
    }
    
    
    func getMillisecond(hours: String) -> Int {
        
        let currentDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        // Convert Date to String
        let dateString = dateFormat.string(from: currentDate)
        
        let isoDate = "\(dateString), " + hours
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd/yyyy, HH:mm"
        
        let date = dateFormatter.date(from:isoDate)
        print("Date\(date)")
        let nowDouble = date?.timeIntervalSince1970
        let t = Int(nowDouble! * 1000)
        return t
    }
    //Convert to hours
    
    func toDate(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    // Convert 12 hours format to 24 hours Format
    
    func convertMilitaryTimeToNoneMilitaryTime(time: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // fixes nil if device time in 24 hour format
        let date = dateFormatter.date(from: time) ?? Date()
        
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.string(from: date)
        print("24Hours Format Visit Time",date24)
        return date24
    }
    // Convert to correct Date & Time
    
    func dateFormatter(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd hh:mm a"
        let result = formatter.string(from: date)
        print(result)
        
        let addedDate = result
        let objformatter = DateFormatter()
        objformatter.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
        objformatter.dateFormat = "yyyy-MMM-dd hh:mm a"
        let date1 = objformatter.date(from: addedDate)
        print("DATE \(String(describing: date1!))")
        return date1!
    }
    
    func fromMillisToDate(millis: Double) -> Date {
        return Date(timeIntervalSince1970: (millis) / 1000)
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    func fromDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date)
    }
    
    
    func getDateInString(dates: Int) -> String {
        let date = fromMillisToDate(millis: Double(dates))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateInString = dateFormatter.string(from: date)
        return dateInString
    }
}
