//
//  TimeOffVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 25.06.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FSCalendar

//@objc protocol CalendarTimeOffDelegate: class {
//    func calendarTapped()
//}

class TimeOffVC: BaseViewController {
    enum TimeOffVCState {
        case add
        case edit
    }
    enum WeekendTypes: CaseIterable {
        case businessTrip
        case sickLeave
        case other
        
        var title: String {
            switch self {
                
            case .businessTrip:
                return "Business trip"
            case .sickLeave:
                return "Sick leave"
            case .other:
                return "Other"
            }
        }
    }
    // MARK: -UI Property
    private let scrollView = UIScrollView()
    private let mainView = UIView()
    
    
    private let closebutton: UIButton = {
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
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 30)
        label.textColor = .color293147
        return label
    }()
    
    //name
    private let arrowImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = R.image.bottomButtonArrow()
        imageView.tintColor = .color293147
        return imageView
    }()
    private let takingTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.configure(placeholder: "I`m taking*")
        textField.titleFont =  R.font.aileronSemiBold(size: 16)!
        textField.placeholderColor = .color606572
        textField.text = "Sick leave"
        textField.isUserInteractionEnabled = false
        return textField
    }()
    private let weekendButton: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(weekendButtonTouched), for: .touchUpInside)
        return button
    }()
    //name list
    lazy var weekendTableView: UITableView = {
        let tableView = UITableView()
        tableView.cornerRadius = 8
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints {
            $0.height.equalTo( WeekendTypes.allCases.count * 40)
        }
        tableView.isScrollEnabled = false
        return tableView
    }()
    lazy var weekendListView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.shadowColor = UIColor(red: 0.376, green: 0.396, blue: 0.447, alpha: 0.1)
        view.shadowOpacity = 1
        view.shadowRadius = 15
        view.shadowOffset = CGSize(width: 0, height: 4)
        view.addSubview(weekendTableView)
        weekendTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return view
    }()
    //date
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date *"
        label.textColor = UIColor(red: 0.375, green: 0.395, blue: 0.446, alpha: 1)
        label.font = R.font.aileronSemiBold(size: 16)
        return label
    }()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
//    private lazy var calendarView: CalendarTimeOffView = {
//        let view = CalendarTimeOffView()
//        view.delegateCalendar = self
//        return view
//    } ()
    private lazy var calendarView: FSCalendar = {
        let vwCalander = FSCalendar()
        setCalendar()
        return vwCalander
    } ()

    //notes
    private let notesLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color606572
        label.text = "Notes"
        return label
    }()
    private lazy var notesTextView: UITextView = {
        let textView = UITextView()
        textView.font = R.font.aileronRegular(size: 14)
        textView.textColor = .color070F24
        textView.delegate = self
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorC6222F
        return view
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 15
        button.redAndGrayStyle(active: false)
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 18)
        button.addTarget(self, action: #selector(confirmButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var fewDaysCheckboxButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .fewDays, typeOfCheckbox: .blackPoint, typeOfText: .black)
        button.delegate = self
        button.isUserInteractionEnabled = true
        button.setupCalendarFont()
        return button
    }()
    
    private lazy var separatedDaysCheckboxButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .separatedDays, typeOfCheckbox: .blackPoint, typeOfText: .black)
        button.delegate = self
        button.isUserInteractionEnabled = true
        button.setupCalendarFont()
        return button
    }()
    
    private lazy var alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.delegate = self
        return view
    }()

    // MARK: - Property
    
    private var state: TimeOffVCState
    private var timeOffType = "sick"
    private var notes: String?
    private var isValid = false
    private var firstDate:Date?
    private var lastDate: Date?
    var id = String()
    var getDates = [Int]()
    var notesGet: String?
    var dateArr = [String]()
    var arrs = [Date]()
    var datesRange: [Date] = [Date]()
    weak var delegate: EmployeeTimeOffDelegate?
    private var dateChoiceType = String()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Datessss",getDates)
        self.view.backgroundColor = .white
        fewDaysCheckboxButton.vkl()
        notesTextView.text = notesGet
        dateChoiceType = "range"
        arr()
        setCalendar()
        setupLayouts()
        if state == .edit {
            isValid = true
            confirmButton.redAndGrayStyle(active: true)
        } else {
            isValid = false
        }
    }
    
    init(state: TimeOffVCState) {
        self.state = state
        switch state {
        case .add:
            mainLabel.text = "Add time off"
        case .edit:
            mainLabel.text = "Edit time off"
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Layout
extension TimeOffVC {
    private func setupLayouts() {
        setupScrollViewLayouts()
        mainView.addSubviews([closebutton, mainLabel, takingTextField, arrowImageView, weekendButton, dateLabel, calendarView, notesLabel, notesTextView, separatorView, confirmButton, fewDaysCheckboxButton, separatedDaysCheckboxButton])
        
        closebutton.snp.makeConstraints {
            $0.size.equalTo(17)
            $0.leading.equalToSuperview().inset(15)
            $0.top.equalTo(mainView.safeAreaLayoutGuide).inset(38)
        }
        
        mainLabel.snp.makeConstraints {
            $0.leading.equalTo(closebutton.snp.trailing).offset(20)
            $0.top.equalTo(mainView.safeAreaLayoutGuide).inset(26)
        }
        
        takingTextField.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(35)
            $0.height.equalTo(52)
            $0.leading.equalToSuperview().inset(25)
            $0.width.equalTo(150)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalTo(takingTextField)
            $0.height.equalTo(7)
            $0.width.equalTo(12)
            $0.centerY.equalTo(takingTextField.textInputView)
        }
        
        weekendButton.snp.makeConstraints {
            $0.edges.equalTo(takingTextField)
        }

        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(takingTextField.snp.bottom).offset(25)
        }

        fewDaysCheckboxButton.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(150)
        }

        separatedDaysCheckboxButton.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.right.equalToSuperview().offset(-25)
//            $0.left.equalTo(fewDaysCheckboxButton.snp.right).offset(19)
            $0.width.equalTo(150)
        }

        calendarView.snp.makeConstraints {
            $0.top.equalTo(fewDaysCheckboxButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(310)
        }
        
        notesLabel.snp.makeConstraints {
            $0.leading.equalTo(takingTextField)
            $0.top.equalTo(calendarView.snp.bottom).offset(10)
        }
        
        notesTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(notesLabel.snp.bottom).offset(18)
            $0.height.greaterThanOrEqualTo(40)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(notesTextView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(notesTextView)
            $0.height.equalTo(2)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.top.greaterThanOrEqualTo(separatorView.snp.bottom).offset(38)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func setupScrollViewLayouts() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            $0.left.right.equalTo(self.scrollView.contentLayoutGuide)
            $0.width.equalTo(self.scrollView.frameLayoutGuide)
        }
    }
    
    func setCalendar(){
        self.calendarView = FSCalendar(frame: .zero)
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.today = nil
        self.calendarView.allowsMultipleSelection = true
        self.calendarView.appearance.titleTodayColor = UIColor.color606572
        self.calendarView.appearance.weekdayTextColor = UIColor.color606572
        self.calendarView.appearance.selectionColor = UIColor.color860000
        self.calendarView.appearance.headerTitleColor = UIColor.color606572
    }
    
    func arr() {
       
        for i in 0..<getDates.count {
            let dateInInt = TimeInterval(getDates[i]) / 1000
            let date = Date(timeIntervalSince1970: dateInInt)
            let dateAccordingToCurrentTimeZone = dateFormatter(date: date)
            
            print("Converted Time \(dateAccordingToCurrentTimeZone)")
            arrs.append(dateAccordingToCurrentTimeZone)
            dateArr.append(dateFormatter.string(from: dateAccordingToCurrentTimeZone))
        }
    }
    
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
    
    func dateRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
}

// MARK: - UITableViewDataSource

extension TimeOffVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekendTypes.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = WeekendTypes.allCases[indexPath.row].title
        cell.textLabel?.font = R.font.aileronRegular(size: 14)
        cell.textLabel?.textColor = .color070F24
        cell.textLabel?.textAlignment = .left
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        takingTextField.text = WeekendTypes.allCases[indexPath.row].title
        switch WeekendTypes.allCases[indexPath.row].title {
        case "Business trip":
            timeOffType = "business-trip"
        case "Sick leave":
            timeOffType = "sick"
        default:
            timeOffType = "other"
        }
        weekendListView.removeFromSuperview()
    }
}

//MARK: - UITableViewDelegate

extension TimeOffVC: UITableViewDelegate {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 40
    }
}

//MARK: - UITextViewDelegate

extension TimeOffVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        notes = textView.text
        
        textView.frame.size.height = textView.contentSize.height
    }
}

//MARK: - ButtonWithTrailingCheckboxDelegate

extension TimeOffVC: ButtonWithTrailingCheckboxDelegate {
    func buttonTapped(questions: ButtonWithTrailingCheckboxComponents, answer: Bool) {
        if questions.titleOflabel == "Multiple Days" && answer == true || questions.titleOflabel == "Single Day" && answer == false {
            separatedDaysCheckboxButton.vukl()
            fewDaysCheckboxButton.vkl()
            confirmButton.redAndGrayStyle(active: false)
            dateChoiceType = "range"
            for i in 0..<datesRange.count {
                calendarView.deselect(datesRange[i])
            }
//            calendarView.updateCalendar(isSeparatedDays: true)
        } else if questions.titleOflabel == "Single Day" && answer == true || questions.titleOflabel == "Multiple Days" && answer == false {
            separatedDaysCheckboxButton.vkl()
            fewDaysCheckboxButton.vukl()
            confirmButton.redAndGrayStyle(active: false)
            dateChoiceType = "separated"
//            calendarView.updateCalendar(isSeparatedDays: false)
        }
    }
}

//MARK: - Network

private extension TimeOffVC {
    func sendTimeOffs() {
        var datesFinal = [Int]()
        
        if dateChoiceType == "range" {
            if let start = CalendarTimeOffStatus.shared.rangeStartedDate, let end = CalendarTimeOffStatus.shared.rangeEndedDate {
                let dates = datesRange(from: start, to: end)
                for i in dates {
                    let timeInterval = i.millisecondsSince1970
                    datesFinal.append(Int(timeInterval))
                }
            }
        } else  {
            for i in datesRange {
                let timeInterval = i.millisecondsSince1970
                datesFinal.append(Int(timeInterval))
            }
        }

        let form = TimeOffsAdding(dateChoiceType: dateChoiceType, timeOffType: timeOffType, dates: datesFinal, notes: notes)
        
        EmployeeService().addTimeOff(form: form) { result in
            switch result {
            case .success(_):
                self.dismiss(animated: true) {
                    self.delegate?.reloadTimeOffs()
                }
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func editTimeOffs() {
        var datesFinal = [Int]()
        if dateChoiceType == "range" {
            if let start = CalendarTimeOffStatus.shared.rangeStartedDate, let end = CalendarTimeOffStatus.shared.rangeEndedDate {
                let dates = datesRange(from: start, to: end)
                for i in dates {
                    let timeInterval = i.millisecondsSince1970
                    datesFinal.append(Int(timeInterval))
                }
            }
        } else if dateChoiceType == "separated" {
            for i in datesRange {
                let timeInterval = i.millisecondsSince1970
                datesFinal.append(Int(timeInterval))
            }
        }
        
        let form = TimeOffsAdding(dateChoiceType: dateChoiceType, timeOffType: timeOffType, dates: datesFinal, notes: notes)
        
        EmployeeService().editTimeOff(id: id, form: form) { result in
            switch result {
            case .success(let success):
                self.dismiss(animated: true) {
                    self.delegate?.reloadTimeOffs()
                }
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
}

//MARK: - Actions

extension TimeOffVC {
    @objc func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmButtonTouched() {
        if let title = mainLabel.text {
            if title == "Edit time off" {
                if isValid {
                    editTimeOffs()
                }
            } else if title == "Add time off" {
                if isValid {
                    sendTimeOffs()
                }
            }
        }
    }
    
    @objc func weekendButtonTouched() {
        view.addSubview(weekendListView)
        weekendListView.snp.makeConstraints {
            $0.leading.trailing.equalTo(takingTextField)
            $0.top.equalTo(takingTextField.snp.bottom).offset(12)
        }
    }
}

//MARK: - Setup dates

private extension TimeOffVC {
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
}

extension TimeOffVC : FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
   
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {

        let dateString = self.dateFormatter.string(from: date)

        if self.dateArr.contains(dateString) {
            calendarView.appearance.titleSelectionColor = .white
            return UIColor.color860000
        } else {
            return UIColor.clear
        }
    
    }

    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let currentDay = Date()
        return currentDay
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let date = dateFormatter(date: date)
        
        if dateArr.count != 0 {
            dateArr.removeAll()
            for i in 0..<arrs.count {
                
                calendar.deselect(arrs[i])
                 
            }
            arrs.removeAll()
            calendarView.reloadData()
        }
        if dateChoiceType == "range" {
            if firstDate == nil {
                firstDate = date
                datesRange = [firstDate!]
                
                print("datesRange contains: \(datesRange)")
                
                return
            }
            
            if firstDate != nil && lastDate == nil {
                // handle the case of if the last date is less than the first date:
                if lastDate == nil {
                    confirmButton.redAndGrayStyle(active: false)
                }
                if date <= firstDate! {
                    calendar.deselect(firstDate!)
                    firstDate = date
                    datesRange = [firstDate!]
                    
                    print("datesRange contains: \(datesRange)")
                    
                    return
                }
                
                let range = dateRange(from: firstDate!, to: date)
                
                lastDate = range.last!
                CalendarTimeOffStatus.shared.rangeStartedDate = firstDate
                CalendarTimeOffStatus.shared.rangeEndedDate = lastDate
                
                for d in range {
                    calendar.select(d)
                }
                
                datesRange = range
                
                print("datesRange contains: \(datesRange)")
                confirmButton.redAndGrayStyle(active: true)
                isValid = true
//                rangeDateChanged()
                return
                
            }
            if firstDate != nil && lastDate != nil {
                for d in datesRange {
                    calendar.deselect(d)
                }
                datesRange.removeAll()
                firstDate = nil
                lastDate = nil
            }
            
        }  else {
            datesRange.append(date)
            firstDate = datesRange.min()
            lastDate = datesRange.max()
            confirmButton.redAndGrayStyle(active: true)
            isValid = true
        }

    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let date = dateFormatter(date: date)
        if dateChoiceType == "range" {
            for d in calendar.selectedDates {
                calendar.deselect(d)
                datesRange.removeAll()
                CalendarTimeOffStatus.shared.rangeStartedDate = nil
                CalendarTimeOffStatus.shared.rangeEndedDate = nil
                firstDate = nil
                lastDate = nil
            }
        } else {
           
            calendar.deselect(date)
            for i in 0..<datesRange.count {
                if datesRange[i] == date {
                    datesRange.remove(at: i)
                    break
                }
            }
            
            CalendarTimeOffStatus.shared.rangeStartedDate = datesRange.min()
            CalendarTimeOffStatus.shared.rangeEndedDate = datesRange.max()
            firstDate = datesRange.min()
            lastDate = datesRange.max()
//            if datesRange.count == 0 {
//                isCalendarActive = false
//            }
        }
        print("Date Range:-------",datesRange)
    }
}
    
