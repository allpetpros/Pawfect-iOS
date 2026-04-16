//
//  MeetNGreetVC.swift
//  p103-customer
//
//  Created by Foram Mehta on 25/04/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MeetNGreetVC: BaseViewController, UITextFieldDelegate {
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = R.font.aileronBold(size: 30)
        label.textColor = .color293147
        label.text = "Meet & Greet"
        return label
    }()
    
    let closebutton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.closeTest(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.clipsToBounds = true
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var meetNGreetDateTxtField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Select Date*")
        return tf
    } ()
    
    private let calendarIconBtn: UIButton = {
        let b = UIButton()
        let image = UIImage(named: "calendar-1")
        b.setImage(image, for: .normal)
        return b
    }()
    
    
    private lazy var meetNGreetTimeTxtField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Select Time*")
        meetNGreetDateTxtField.delegate = self
        return tf
    } ()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronRegular(size: 12)
        label.textColor = .color606572
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Please enter a preferred date & time for your consult to be scheduled. **This may change due to coordination with the sitter and their availability."
//        label.text = "Please enter a preferred date & time for your consult to be scheduled.**This may change due to coordination with the sitter and their availability."
        
        return label
    }()
    
    let scheduleButton: UIButton = {
        let b = UIButton()
        b.cornerRadius = 15
        b.setTitle("Schedule", for: .normal)
        b.titleLabel?.font = R.font.aileronBold(size: 18)
        b.redAndGrayStyle(active: false)
        b.isUserInteractionEnabled = false
        b.addTarget(self, action: #selector(scheduleButtonTouched), for: .touchUpInside)
        return b
    } ()
    
    let meetNGreetSuccessLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 16)
        label.textColor = .colorC6222F
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    // MARKS:- Properties:
    var delegate: ReloadData?
    var greetServiceDatePicker = UIDatePicker()
    var greetServiceTimePicker = UIDatePicker()
    var dateString = String()
    var timeInMilitaryTime = String()
    var timeString = String()
    var dateTime = Int()
    var meetandGreetSchedule = Int()
    var meetNGreetId = "78ca3b0a-f454-4381-87a6-aad2dde901c8"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setDatePicker()
        setTimePicker()
        setupLayouts()
        getMeetNGreetScheduledTime()
//        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: true) {
//            self.delegate?.reloadData()
        }
    }
    //MARK:- Private Methods
    private func getMeetNGreetScheduledTime() {
        if meetandGreetSchedule != 0 {
            self.meetNGreetSuccessLabel.text = UserDefaults.standard.string(forKey: "MeetNGreetSuccess")
            meetNGreetTimeTxtField.text = getTimeInString(millis: Int64(meetandGreetSchedule))
            meetNGreetDateTxtField.text = getDateInString(millis: Int64(meetandGreetSchedule))
            meetNGreetTimeTxtField.isUserInteractionEnabled = false
            meetNGreetDateTxtField.isUserInteractionEnabled = false
            closebutton.isHidden = false
        } else {
            closebutton.isHidden = true
            meetNGreetTimeTxtField.isUserInteractionEnabled = true
            meetNGreetDateTxtField.isUserInteractionEnabled = true
        }
    }
    
    private func setDatePicker() {
        greetServiceDatePicker.datePickerMode = .date
        greetServiceDatePicker.contentHorizontalAlignment = .center
        if #available(iOS 13.4, *) {
            greetServiceDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        greetServiceDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        greetServiceDatePicker.contentMode = .center
        meetNGreetDateTxtField.inputView = greetServiceDatePicker
        
        greetServiceDatePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        meetNGreetDateTxtField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(handleDatePicker))
    }
    
    private func setTimePicker() {
        greetServiceTimePicker.datePickerMode = .time
        greetServiceTimePicker.contentHorizontalAlignment = .center
//       / greetServiceDatePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            greetServiceTimePicker.preferredDatePickerStyle = .wheels
        } else {
             
        }
        greetServiceTimePicker.contentMode = .center
        meetNGreetTimeTxtField.inputView = greetServiceTimePicker
        greetServiceTimePicker.addTarget(self, action: #selector(handleTimePicker), for: .valueChanged)

        meetNGreetTimeTxtField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(handleTimePicker))
//        greetServiceTimePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .allEvents)
    }
    
    private func setupLayouts() {
        view.addSubviews([descriptionLabel, closebutton,calendarIconBtn,meetNGreetDateTxtField,meetNGreetTimeTxtField,instructionLabel,scheduleButton,meetNGreetSuccessLabel])
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(38)
        }
        
        closebutton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(15)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(38)
            $0.right.equalToSuperview().offset(-25)
        }
        
        meetNGreetDateTxtField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
           
        }
        
        calendarIconBtn.snp.makeConstraints {
            //            $0.top.equalToSuperview()
            $0.right.equalToSuperview().offset(-35)
            $0.bottom.equalTo(meetNGreetDateTxtField.snp.bottom).offset(-8)
            $0.height.equalTo(20)
            $0.width.equalTo(20)
            
        }
        
        meetNGreetTimeTxtField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.top.equalTo(meetNGreetDateTxtField.snp.bottom).offset(20)
        }
        
        instructionLabel.snp.makeConstraints {
            $0.top.equalTo(meetNGreetTimeTxtField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            
        }
        scheduleButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.top.equalTo(instructionLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        meetNGreetSuccessLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.top.equalTo(scheduleButton.snp.bottom).offset(20)
        }
        
    }
    
    private func checkState(){
        if meetNGreetTimeTxtField.text != "" && meetNGreetDateTxtField.text != "" {
            getMillisecond(date: dateString, hours: timeString)
            scheduleButton.isUserInteractionEnabled = true
            scheduleButton.redAndGrayStyle(active: true)
          
        } else {
            scheduleButton.isUserInteractionEnabled = false
            scheduleButton.redAndGrayStyle(active: false)
        }
    }
    
    //MARK:- Actions
    
    @objc func closeButtonTouched() {
        
        dismiss(animated: true) {
            self.delegate?.reloadMeetNGreet()
        }
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
//        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateString = dateFormatter.string(from: greetServiceDatePicker.date)
        print(dateString)
        meetNGreetDateTxtField.text = dateString
        checkState()
    }
    
    @objc func handleTimePicker() {
//        print(sender.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeInMilitaryTime = dateFormatter.string(from: greetServiceTimePicker.date)
        
        timeString = CommonFunction.shared.convertTimeTOHoursFormat(time: timeInMilitaryTime)
        meetNGreetTimeTxtField.text = timeString
        print(timeString)
        checkState()
    }
    
    @objc func scheduleButtonTouched(sender: UIButton) {
        
        CustomerService().createMeetNGreetOrder(extrasIds: meetNGreetId, date: dateTime) { result in
            print(result)
            switch result {
            case .success(let userData):
                print("result",userData)
                self.dismiss(animated: true) {
                    self.delegate?.reloadMeetNGreet()
                }
//                UserDefaults.standard.set("Please wait untill your Meet & Greet get procceed", forKey: "MeetNGreetSuccess")
//                self.meetNGreetSuccessLabel.text = UserDefaults.standard.string(forKey: "MeetNGreetSuccess")
//                self.setupWarning(alert: "Please wait untill your Meet & Greet get procceed", isOrders: true)
                self.scheduleButton.isUserInteractionEnabled = false
                self.scheduleButton.redAndGrayStyle(active: false)
                
            case .failure(let error):
                print(error)
                self.setupErrorAlert(error: error)
            }
        }
    }
}

extension MeetNGreetVC {
    // Date Time Conversion
    func getMillisecond(date:String,hours: String) -> Int {
        let dateWithNonMilitaryTime = "\(dateString), " + "\(timeInMilitaryTime)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
        let date = dateFormatter.date(from:dateWithNonMilitaryTime)
        print("Date\(date)")
        
     
        if date != nil {
            let nowDouble = (date?.timeIntervalSince1970)!
            dateTime = Int(nowDouble * 1000)
            return dateTime
        } else  {
            return 0
        }
    }
    
    func getTimeInString(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        let dateString =  dateFormatter.string(from: date)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm"

        let dat = dateFormatter1.date(from: dateString)
        dateFormatter1.timeZone = TimeZone.current
//        dateFormatter1.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
        dateFormatter1.dateFormat = "hh:mm a"
        let Date12 = dateFormatter1.string(from: dat ?? Date())
        print("12 hour formatted Date:",Date12)
        return Date12
    }
    
    func getDateInString(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        return dateFormatter.string(from: date)
        
        
    }
    
}


    
