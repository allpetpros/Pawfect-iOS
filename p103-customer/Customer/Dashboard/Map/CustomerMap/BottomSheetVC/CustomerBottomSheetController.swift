//
//  CustomerBottomSheetController.swift
//  p103-customer
//
//  Created by SOTSYS371 on 16/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import FittedSheets
enum CustomerMapState {
    case topView
    case employeeArriveView
    case petActionView
    case summaryView
}

var isOrderFinished = Bool()

class CustomerBottomSheetController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var stepTableView: UITableView!
    
    //MARK: - Properties
    var customerMapStateArr = [CustomerMapState]()
  
    var employeeDetails: EmployeeDetail?
    var delegate: CustomerMapDelegate?
    var service: Service?
    var mapDelegate: CustomerMapOrderDelegate?
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callCustomerMapDetails()
        stepTableView.delegate = self
        stepTableView.dataSource = self
        stepTableView.register(UINib(nibName: "MapTopViewCll", bundle: nil), forCellReuseIdentifier: "MapTopViewCll")
        stepTableView.register(UINib(nibName: "CustomerEmployeeArrivesCell", bundle: nil), forCellReuseIdentifier: "CustomerEmployeeArrivesCell")
        stepTableView.register(UINib(nibName: "CustomerPetActionCell", bundle: nil), forCellReuseIdentifier: "CustomerPetActionCell")
        stepTableView.register(UINib(nibName: "CustomerSummaryTableCell", bundle: nil), forCellReuseIdentifier: "CustomerSummaryTableCell")
        customerMapStateArr.append(.topView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("next"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("time"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("finish"), object: nil)
        
    }
 
}


//MARK:- UITableview Delegate & Datasource
extension CustomerBottomSheetController: UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerMapStateArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let map : CustomerMapState = customerMapStateArr[indexPath.row]
        switch map {
        case .topView:
            let cell: MapTopViewCll = stepTableView.dequeueReusableCell(withIdentifier: "MapTopViewCll") as! MapTopViewCll
            let urlString = URL(string: employeeDetails?.imageURL ?? "")
            cell.employeeImage.sd_setImage(with: urlString, placeholderImage: R.image.employee_test())
            cell.employeeName.text = employeeDetails?.name
            
          
            cell.employeeRatings.rating = Double(employeeDetails?.rating ?? 0)
            return cell
            
        case .employeeArriveView:
            let cell = stepTableView.dequeueReusableCell(withIdentifier: "CustomerEmployeeArrivesCell") as! CustomerEmployeeArrivesCell
            cell.setupUI()
            return cell
            
        case .petActionView:
            let cell = stepTableView.dequeueReusableCell(withIdentifier: "CustomerPetActionCell") as! CustomerPetActionCell
                
            let arr = checkListStartArr.compactMap { $0.attachmentUrls}.flatMap {$0}
            cell.serviceNameLabel.text = service?.title
            print(arr)
            
            if arr.count > 0 {
                cell.petCollectionView.isHidden = false
                cell.imageArr = arr
            } else {
                cell.petCollectionView.isHidden = true
            }
            cell.setUI()
            cell.petCollectionView.reloadData()
            cell.petActionTableView.reloadData()
            return cell
        case .summaryView:
            let cell = stepTableView.dequeueReusableCell(withIdentifier: "CustomerSummaryTableCell") as! CustomerSummaryTableCell
            cell.setupUI()
            cell.summaryDataTableView.reloadData()
            cell.doneButtonTapped.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
            return cell
        }
    }
}

//MARK: - Network
extension CustomerBottomSheetController {
    func callCustomerMapDetails() {
        checkListStartArr.removeAll()
        CustomerService().getMapOrderDetail(id: selectedOrderId) { result in
            
            switch result {
            case .success(let data):
                print(data)
                customerHomeSourceLong = data.customerHomePosition.long
                customerHomeSourcelat = data.customerHomePosition.lat
                self.employeeDetails = data.employee
                customerCheckListArr = data.checklist
                customerPointArr = data.points
                for i in 0..<customerCheckListArr.count {
                    if customerCheckListArr[i].dateStart != nil{
                        checkListStartArr.append(customerCheckListArr[i])
                    }
                }
                if checkListStartArr.count > 0 {
                    if self.customerMapStateArr.count == 1 {
                        self.customerMapStateArr.append(.employeeArriveView)
                        self.customerMapStateArr.append(.petActionView)
                    }
                }
                let filteredData = checkListStartArr.unique{$0.name}
                checkListStartArr = filteredData
                if notificationType == "time" {
                    NotificationCenter.default.post(name: Notification.Name("path"), object: nil)
                    notificationType = ""
                }
                self.stepTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}


//MARK: - Custom Method
extension CustomerBottomSheetController {

    func summary() {
        summaryArray.removeAll()
        let startTime = MapSummaryStruct(name: "Start Time", starttime: customerCheckListArr[0].dateStart ?? 0)
        
        summaryArray.append(startTime)
        let endTime = MapSummaryStruct(name: "End Time", starttime: customerCheckListArr.last?.dateStart ?? 0)
        for i in 0..<customerCheckListArr.count{
            let data = MapSummaryStruct(name:customerCheckListArr[i].name, starttime: customerCheckListArr[i].dateStart ?? 0)
            summaryArray.append(data)
        }
        summaryArray.append(endTime)
        
    }
}

//MARK: - Actions
extension CustomerBottomSheetController {
    @objc func doneButtonTapped() {
        
        self.dismiss(animated: true) {
            self.mapDelegate?.reloadCustomerMapData()
        }
    }
}

//MARK: - NSNotification Methods
extension CustomerBottomSheetController {
    @objc func methodOfReceivedNotification(notification: NSNotification){
        print("Called")
       
        if isOrderFinished {
            summary()
            self.customerMapStateArr.append(.summaryView)
            stepTableView.reloadData()
            isOrderFinished = false
        } else {
            callCustomerMapDetails()
        }
    }
    
}
//MARK: - Remove Duplicate entry from Array
extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}

