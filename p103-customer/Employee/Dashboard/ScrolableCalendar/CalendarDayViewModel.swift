//
//  CalendarDayViewModel.swift
//  p103-customer
//
//  Created by Daria Pr on 28.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

@objc protocol CalendarDayDelegate: class {
    func get(day: Date)
    func reloadDates()
}

class CalendarDayViewModel: NSObject {
    
    //MARK: - Properties
    
    private let date = Date()
    var calendarArray = [Date]()
    var currentMonthInRange = Date()
    var selectedIndex = IndexPath()
    var currentDayIndex = IndexPath()
    var currentDay = String()
    var calendarDayDict = [Date: Bool]()
    var current = Date()
    weak var delegate: CalendarDayDelegate?
    
    //MARK: - Setup
    
    override init() {
        super.init()

        self.calendarArray = datesRange(from: date.startOfDay, to: date.endOfMonth)
        current = current - TimeInterval(TimeZone.current.secondsFromGMT())
        for i in calendarArray {
            calendarDayDict[i] = false
        }
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd"
        let formattedDate = format.string(from: date)
        currentDay = formattedDate
    }
    
    func currentMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        array.removeLast()
        
        return array
    }
    
    func getPreviousMonth(date:Date)->Date {
        return Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    func getNextMonth(date:Date)->Date {
        return Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
}

//MARK: - ICollectionViewDelegate, UICollectionViewDataSource

extension CalendarDayViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        calendarArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateChooserCollectionViewCell.className, for: indexPath) as! DateChooserCollectionViewCell
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MMM d"
        let dateString = dateFormatter.string(from: self.calendarArray[indexPath.row])
        let currentDay = dateFormatter.string(from: date)

        if dateString == currentDay {
            cell.dateLabel.text = "Today"
        } else {
            cell.dateLabel.text = dateString
        }

        if calendarDayDict[calendarArray[indexPath.row]] == true {
            cell.setupHighlighted()
        } else {
            cell.setupUnhighlighted()
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateChooserCollectionViewCell.className, for: indexPath) as! DateChooserCollectionViewCell
        for i in calendarArray {
            calendarDayDict[i] = false
        }
//        calendarDayDict[calendarArray[indexPath.row]] = true
//
        if let cellCurrent = collectionView.cellForItem(at: indexPath) as? DateChooserCollectionViewCell {
            if calendarDayDict[calendarArray[indexPath.row]] == true {
                cellCurrent.setupHighlighted()
            }
     
            delegate?.get(day: calendarArray[indexPath.row])
            OrderManager.shared.calendarDayDate = calendarArray[indexPath.row]
            selectedIndex = indexPath
        
        }
//
        checkState(date: calendarArray[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cellCurrent = collectionView.cellForItem(at: indexPath) as? DateChooserCollectionViewCell {
            cellCurrent.setupUnhighlighted()
        }
    }
}

//MARK: - Check state of cell
 extension CalendarDayViewModel {
    func checkState(date: Date) {
        for (key, _) in calendarDayDict {
            calendarDayDict[key] = false
        }
        
        calendarDayDict[date] = true
        delegate?.reloadDates()
    }
}
