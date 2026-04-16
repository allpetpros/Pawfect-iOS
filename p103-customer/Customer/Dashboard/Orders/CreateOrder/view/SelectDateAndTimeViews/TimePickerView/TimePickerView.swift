//
//  TimePickerView.swift
//  p103-customer
//
//  Created by Alex Lebedev on 29.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

@objc protocol PickerTimeDelegate: class {
    func timeMorningChoosen(time: [String])
    func timeAfternoonChoosen(time: [String])
    func timeEveningChoosen(time: [String])
    func totalTime(time: [String])
}

class TimePickerView: UIView {
    
    //MARK: - Properties
    
    var hours = ["01", "02", "03", "04", "05", "06","07", "08", "09", "10", "11", "12"]
    
    let morningHours = ["07", "08", "09", "10"]
//    private let morningHours = ["07", "08", "09", "10", "11"]
    let afternoonHours = ["12", "01", "02", "03"]
//    private let afternoonHours = ["12", "1", "2", "3", "4"]
    
    let eveningHours = ["05", "06", "07"]
    
    let totalHours = ["01", "02", "03", "04", "05", "06","07", "08", "09", "10", "11", "12"]
//    private let eveningHours = ["5", "6", "7", "8"]
    
    var amountOfHours = 12
    
    var minutes = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    
    private var partOfDay = String()
    var totalTime = ["01", "00"]
    var morningTime = ["07", "00"]
    var afternoonTime = ["12", "00"]
    var eveningTime = ["05", "00"]
    
    weak var delegate: PickerTimeDelegate?
    
    //MARK: - UIProperties
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var timePickerView: UIPickerView!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TimePickerView", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.bounds
        self.isUserInteractionEnabled = true
        timePickerView.delegate = self
        timePickerView.dataSource = self
        timePickerView.backgroundColor = R.color.pickerColor()?.withAlphaComponent(0.3)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension TimePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return amountOfHours
        } else {
            return 60
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
      
        timePickerView.subviews[1].backgroundColor = UIColor.clear
        let label = UILabel()
        label.font = R.font.aileronRegular(size: 36)
        label.textAlignment = .center
        
        if component == 0 {
            label.text = hours[row]
        } else {
            label.text = minutes[row]
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch partOfDay {
        case "morning":
            setupMorning(component: component, row: row)
        case "afternoon":
            setupAfternoon(component: component, row: row)
        case "evening":
            setupEvening(component: component, row: row)
        case "total":
            setupTotal(component: component, row: row)
        default:
            break
        }
    }
    
    func setupMorning(component: Int, row: Int) {
        
        if component == 0 {
            morningTime[0] = morningHours[row]
        } else if component == 1 {
            
//            if morningTime[0] == "10" {
//                timePickerView.selectRow(0, inComponent: 1, animated: false)
//                morningTime[1] = minutes[0]
//                print(morningTime)
//            } else {
                morningTime[1] = minutes[row]
//            }
            
        }
        delegate?.timeMorningChoosen(time: morningTime)
    }
    
    func setupAfternoon(component: Int, row: Int) {
        if component == 0 {
            afternoonTime[0] = afternoonHours[row]
        } else if component == 1 {
            afternoonTime[1] = minutes[row]
        }
        delegate?.timeAfternoonChoosen(time: afternoonTime)
    }
    
    func setupEvening(component: Int, row: Int) {
        if component == 0 {
            eveningTime[0] = eveningHours[row]
        } else if component == 1 {
            eveningTime[1] = minutes[row]
        }
        delegate?.timeEveningChoosen(time: eveningTime)
    }
    func setupTotal(component: Int, row: Int) {
        if component == 0 {
            totalTime[0] = hours[row]
        } else if component == 1 {
            totalTime[1] = minutes[row]
        }
    }
}

//MARK: - Public funcs

extension TimePickerView {
    func morningPickerUpdate() {
        partOfDay = "morning"
        hours = morningHours
        amountOfHours = 4
        timePickerView.reloadAllComponents()
    }
    
    func afternoonPickerUpdate() {
        partOfDay = "afternoon"
        hours = afternoonHours
        amountOfHours = 4
        timePickerView.reloadAllComponents()
    }
    
    func eveningPickerUpdate() {
        partOfDay = "evening"
        amountOfHours = 3
        hours = eveningHours
        timePickerView.reloadAllComponents()
    }
    
    func TotalPickerUpdate() {
        partOfDay = "total"
        amountOfHours = 12
        hours = totalHours
        timePickerView.reloadAllComponents()
    }
    
    func resetPicker() {
        timePickerView.selectRow(0, inComponent: 0, animated: false)
        timePickerView.selectRow(0, inComponent: 1, animated: false)
        pickerView(timePickerView, didSelectRow: 0, inComponent: 0)
    }
}
