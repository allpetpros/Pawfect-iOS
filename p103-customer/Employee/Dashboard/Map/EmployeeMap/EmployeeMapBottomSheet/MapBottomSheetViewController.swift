//
//  MapBottomSheetViewController.swift
//  p103-customer
//
//  Created by SOTSYS371 on 24/05/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import FittedSheets
enum MapviewState {
    case topView
    case employeeArriveView
    case petActionView
    case summaryView
}

@objc protocol maintainStepsView: AnyObject {
    func reloadData()
}

var imageDataArr = [Any]()

class MapBottomSheetViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var stepTblView: UITableView!
    @IBOutlet weak var goToDestinationLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    var tabBarHeight = Int()
    var id = String()
    var service: ServiceId?
    var totalTime = String()
    var timer = Timer()
    var totalCount = 0
    var timerIndex: Int?
    var mapPosition: MapPosition = MapPosition(positions: [])
    var isPaused = false
    var isPetActionAdded = false
    var isPetActionCompleted = false
    var summaryArray = [MapSummaryStruct]()
    var delegate: MapDelegate?
    var mapDelegate: EmployeeMapDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTime = 0
        bottomConstraint.constant = CGFloat(tabBarHeight + 20)
        stepTblView.delegate = self
        stepTblView.dataSource = self
       
        registerCell()
        
        var totalTime = Int()
        for i in 0..<checkListArray.count {
            if checkListArray[i].actions?.count ?? 0 > 0 {
                if checkListArray[i].actions?[0].time != 0 && checkListArray[i].dateStart != 0 {
                    let differnceIntTime = (checkListArray[i].actions?[0].time ?? 0) - (checkListArray[i].dateStart ?? 0)
                    totalTime += differnceIntTime
                }
            }
            if checkListArray[i].dateStart == nil {
                if currentTime > 0 {
                    checkListArray[i].status = "working"
                } else {
                    checkListArray[i].status = "waiting"
                }
             
               break
           }else if checkListArray[i].dateStart != nil {
                if checkListArray[i].actions?.count == 0 {
                    checkListArray[i].status = "working"
                    break
                } else if checkListArray[i].actions?.count ?? 0 > 0 {
                    checkListArray[i].status = "completed"
                }
            }
        }
        print(totalTime)
        
        seconds = totalTime / 1000
        if totalTime > 0 {
            isPetActionAdded = true
        }
        var status = checkListArray.flatMap{$0.status}
        
        if status.contains("waiting") || status.isEmpty || status.contains("working") {
            
        } else {
            isPetActionCompleted = true
        }
        
        
        let arr = checkListArray.compactMap { $0.attachmentUrls}.flatMap {$0}
        print(arr)
       
        imageDataArr = arr
        
        stepTblView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
   
}
// MARK: - Custom Methods
extension MapBottomSheetViewController {

    func registerCell() {
        stepTblView.register(UINib(nibName: "TopViewCell", bundle: nil), forCellReuseIdentifier: "TopViewCell")
        stepTblView.register(UINib(nibName: "PetActionTableViewCell", bundle: nil), forCellReuseIdentifier: "PetActionTableViewCell")
        stepTblView.register(UINib(nibName: "EmployeeArrivesCell", bundle: nil), forCellReuseIdentifier: "EmployeeArrivesCell")
        stepTblView.register(UINib(nibName: "SummarryTableViewCell", bundle: nil), forCellReuseIdentifier: "SummarryTableViewCell")
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        print(timer)
    }

    func stopTimer() {
        timer.invalidate()
        stepTblView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func timeString(time:TimeInterval) -> String {
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
        if hours >= 01 {
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format:"%02i:%02i", minutes, seconds)
        }
    }
    
    func summary() {
        summaryArray.removeAll()
        let startTime = MapSummaryStruct(name: "Start Time", starttime: checkListArray[0].dateStart ?? 0)
        
        summaryArray.append(startTime)
        let endTime = MapSummaryStruct(name: "End Time", starttime: checkListArray.last?.dateStart ?? 0)
        for i in 0..<checkListArray.count {
            let data = MapSummaryStruct(name:checkListArray[i].name, starttime: checkListArray[i].dateStart ?? 0)
            summaryArray.append(data)
        }
        summaryArray.append(endTime)
    }
    
}

//MARK: - TableView DataSource and Delegate
extension MapBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapStatArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let map : MapviewState = mapStatArr[indexPath.row]
        switch map {
        case .topView:
            let cell: TopViewCell = stepTblView.dequeueReusableCell(withIdentifier: "TopViewCell") as! TopViewCell
            if mapStatArr.count == 2 {
                cell.startButton.setTitle("Next", for: .normal)
                cell.firstLabel.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
                
            } else if mapStatArr.count == 3 {
                cell.firstLabel.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
                cell.firstLineView.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
                cell.secondLabel.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
                if !isPetActionCompleted {
                    cell.startButton.setTitle("Finish", for: .normal)
                    cell.startButton.redAndGrayStyle(active: false)
                    cell.startButton.isUserInteractionEnabled = false
                } else {
                    cell.startButton.setTitle("Finish", for: .normal)
                    cell.startButton.redAndGrayStyle(active: true)
                    cell.startButton.isUserInteractionEnabled = true
                }
            } else if mapStatArr.count == 4 {
                cell.firstLabel.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
                cell.firstLineView.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
                cell.secondLabel.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
                cell.secondLine.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
                cell.thirdLabel.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
                cell.startButton.setTitle("End", for: .normal)
            }
            if cell.startButton.currentTitle == "Finish" {
                if isPetActionCompleted {
                    cell.startButton.redAndGrayStyle(active: true)
                    cell.isUserInteractionEnabled = true
                } else{
                    cell.startButton.redAndGrayStyle(active: false)
                }
            }
            if isPetActionAdded {
                cell.durationLabel.isHidden = false
            } else {
                cell.durationLabel.isHidden = true
            }
            cell.durationLabel.text =  timeString(time: TimeInterval(seconds))
            cell.startButton.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
            
            return cell
            
        case .employeeArriveView:
            let cell = stepTblView.dequeueReusableCell(withIdentifier: "EmployeeArrivesCell") as! EmployeeArrivesCell
            cell.parent = self
            cell.collectionViewSetUp()
            if mapStatArr.count == 3 {
                cell.attachPhotoButton.isHidden = true
            }
            
            return cell
            
        case .petActionView:
            let cell = stepTblView.dequeueReusableCell(withIdentifier: "PetActionTableViewCell") as! PetActionTableViewCell
            cell.setupUI()
            cell.serviceNameLabel.text = service?.title

            for i in 0..<checkListArray.count {
                if checkListArray[i].dateStart == nil {
                    if currentTime > 0 {
                        checkListArray[i].status = "working"
                    } else {
                        checkListArray[i].status = "waiting"
                    }
                   cell.currentActionTag = i
                   cell.orderCheckId = checkListArray[i].id
                   break
               }else if checkListArray[i].dateStart != nil {
                    if checkListArray[i].actions?.count == 0 {
                        checkListArray[i].status = "working"
                        break
                    } else if checkListArray[i].actions?.count ?? 0 > 0 {
                        checkListArray[i].status = "completed"
                    }
                    
                }
               
            }
            let status = checkListArray.flatMap{$0.status}
            
            if status.contains("waiting") || status.isEmpty || status.contains("working"){
                cell.serviceDurationLabel.isHidden = true
                
            } else {
                cell.attachPhotoButton.isHidden = true
                cell.serviceDurationLabel.isHidden = false
                cell.serviceDurationLabel.text = "Completed"
                isPetActionCompleted = true
            }

            cell.parent = self
            cell.id = id
            cell.collectionViewSetUp()
            cell.petCollectionView.reloadData()
            cell.petActionTableView.reloadData()
            return cell
        case .summaryView:
            let cell = stepTblView.dequeueReusableCell(withIdentifier: "SummarryTableViewCell") as! SummarryTableViewCell
            cell.setupUI()
            cell.summaryArray = summaryArray
            cell.summaryDataTableView.reloadData()
            cell.doneButtonTapped.addTarget(self, action: #selector(doneButtonTapped(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
// MARK: - Action
extension MapBottomSheetViewController {
    @objc func btnAction() {
        
        if mapStatArr.count == 1 {
            mapStatArr.append(.employeeArriveView)
        } else if mapStatArr.count == 2 {
            mapStatArr.append(.petActionView)
        } else if mapStatArr.count == 3 {
            if isPetActionAdded {
                callFinishOrder()
                summary()
                mapStatArr.append(.summaryView)
            }
        }
        if mapStatArr.count > 1 {
            Constant.sheet?.resize(to: .marginFromTop(100))
            
        }
        stepTblView.reloadData()
    }
    
    @objc func doneButtonTapped(sender: UIButton) {
        showActivityIndicator()
        IgnoreInteractionEvents()
         
        sender.redAndGrayStyle(active: false)
        EmployeeService().sendOrderSummary(id: id) { result in
            switch result {
            case .success( _):
                Toast.show(message: "Thank You", controller: self)
                self.endIgnoringEvents()
                seconds = 0
                currentTime = 0
                self.dismiss(animated: true) {
                    self.mapDelegate?.reloadData()
                }
                self.hideActivityIndicator()
            case .failure(let error):
                self.hideActivityIndicator()
                print(error)
            }
        }
    }
    
    @objc func updateTimer() {
        seconds += 1
        currentTime += 1
        print("currentTime",currentTime)
        print(timeString(time: TimeInterval(seconds)))
        if mapStatArr.count != 0 {
            stepTblView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
    
}

//MARK: - Network

extension MapBottomSheetViewController {
    func callFinishOrder() {
        let currentDate = Date()
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = currentDate.timeIntervalSince1970
        // convert to Integer
        let currentDateTime = Int64(timeInterval * 1000)
        let position = PositionsStruct(lat:LocationManager.sharedInstance.latitude, long: LocationManager.sharedInstance.longitude, createdAt: currentDateTime)
        mapPosition.positions.append(position)
        EmployeeService().finishMapOrder(id: id, positions: mapPosition) { result in
            switch result {
            case .success( _):
                print(result)
                self.stepTblView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - InteractionEvents
extension MapBottomSheetViewController {
    func IgnoreInteractionEvents() {
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func endIgnoringEvents(){
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}

