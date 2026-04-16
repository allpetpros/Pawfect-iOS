//
//  CustomerMapViewController.swift
//  p103-customer
//
//  Created by SOTSYS371 on 16/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import FittedSheets

protocol CustomerMapDelegate {
    func fetchRoute()
}

class CustomerMapViewController: UIViewController, GMSMapViewDelegate {
    //MARK: - UIProperties
    private var petsTopView: SittingWithPetView = {
        let view = SittingWithPetView()
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        view.layer.shadowOpacity = 1
        view.backgroundColor = .lightGray
        view.layer.shadowRadius = 15
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.setupEmployeeLayout()
        return view
    }()
    
    //MARK: - Properties
    private var mapView = GMSMapView()
    private var mapMarkers : [GMSMarker] = []
    
    var service: Service?
    var tabBarHeight = 0
    var delegate: CustomerMapOrderDelegate?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("path"), object: nil)
        
        mapView.delegate = self
        callCustomerMapDetails()
        setupLayouts()
        
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: true) {
        }
    }
    
}
//MARK: - Setup Layout
extension CustomerMapViewController {
    
    private func setupLayouts() {
        view.addSubviews([mapView,petsTopView])
        mapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        petsTopView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(76)
        }

        let v = UIView()
        v.backgroundColor = .white
        self.petsTopView.addSubview(v)
        v.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view)
            $0.bottom.equalTo(petsTopView.snp.top)
        }
    }
}

//MARK: - Add BottomsheetView

extension CustomerMapViewController {
    func addBottomSheetView(scrollable: Bool? = true) {
        let bottomSheetVC = CustomerBottomSheetController()
        mapStatArr.removeAll()
        if self.view.frame.height < 700 {
            tabBarHeight = 49
        } else {
            tabBarHeight = 70
        }
  
        let height = 200 + tabBarHeight
        let useInlineMode = view != nil
        Constant.sheet = SheetViewController(
            controller: bottomSheetVC,
            sizes: [.fixed(CGFloat(height)), .marginFromTop(50)],
            options: SheetOptions(useInlineMode: useInlineMode))
        Constant.sheet?.allowPullingPastMaxHeight = false
        Constant.sheet?.allowPullingPastMinHeight = false
        
        Constant.sheet?.dismissOnPull = false
        Constant.sheet?.dismissOnOverlayTap = false
        Constant.sheet?.overlayColor = UIColor.clear
        
        Constant.sheet?.contentViewController.view.layer.shadowColor = UIColor.black.cgColor
        Constant.sheet?.contentViewController.view.layer.shadowOpacity = 0.1
        Constant.sheet?.contentViewController.view.layer.shadowRadius = 10
        Constant.sheet?.allowGestureThroughOverlay = true
        
        bottomSheetVC.service = service
        bottomSheetVC.delegate = self
        bottomSheetVC.mapDelegate = delegate
        addSheetEventLogging(to: Constant.sheet ?? SheetViewController(controller: bottomSheetVC))
        Constant.sheet?.animateIn(to: self.view, in: self)
      
    }
    
    func addSheetEventLogging(to sheet: SheetViewController) {

        let previousDidDismiss = sheet.didDismiss
        sheet.didDismiss = {
            print("did dismiss")
            previousDidDismiss?($0)
        }

        let previousShouldDismiss = sheet.shouldDismiss
        sheet.shouldDismiss = {
            print("should dismiss")
            return previousShouldDismiss?($0) ?? true
        }
        
        let previousSizeChanged = sheet.sizeChanged
        sheet.sizeChanged = { sheet, size, height in
            print("Changed to \(size) with a height of \(height)")
            previousSizeChanged?(sheet, size, height)
        }
        Constant.option?.transitionAnimationOptions.update(with: .curveEaseIn)
    }
}

//MARK: - Draw Map Path

extension CustomerMapViewController {
    func drawPath(from polyStr: String){
        self.mapView.clear()
        self.mapMarkers.removeAll()
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = UIColor(hexString: "#860000")
        polyline.map = mapView// Google MapView
        if customerPointArr.count > 0 {
            for i in 0..<customerPointArr.count {
                let position = CLLocationCoordinate2D(latitude: customerPointArr[i].lat ?? 0.0, longitude: customerPointArr[i].long ?? 0.0)
                let locationmarker = GMSMarker(position: position)
                let customView = CustomMarker.showAlert(title: checkListStartArr[i].name)
                locationmarker.icon = customView.asImage(view: customView)
                locationmarker.map = mapView
                
                mapMarkers.append(locationmarker)
            }
        }
    }
}

//MARK: - Map Delegate

extension CustomerMapViewController: CustomerMapDelegate {
    func fetchRoute() {
        let session = URLSession.shared
        var destinationLat = Double()
        var destinationLong = Double()
        if customerPointArr.count > 0 {
            destinationLat = customerPointArr.last!.lat ?? 0.0
            destinationLong = customerPointArr.last!.long ?? 0.0
        } else {
            destinationLat = customerHomeSourcelat
            destinationLong = customerHomeSourceLong
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: customerHomeSourcelat, longitude: customerHomeSourceLong, zoom: 15.0)

        self.mapView.animate(to: camera)
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(customerHomeSourcelat),\(customerHomeSourceLong)&destination=\(destinationLat),\(destinationLong)&sensor=false&mode=driving&key=\(googleApiKey)")!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any], let jsonResponse = jsonResult as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResponse["routes"] as? [Any] else {
                return
            }
            if routes.count > 0 {
                
                guard let route = routes[0] as? [String: Any] else {
                    return
                }
                guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                    return
                }
                
                guard let polyLineString = overview_polyline["points"] as? String else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.drawPath(from: polyLineString)
                }
                
            } else {
                return
            }
            
        })
        task.resume()
        
    }
}

//MARK: - Action

extension CustomerMapViewController {
    @objc func methodOfReceivedNotification(notification: NSNotification){
        print("Called")
        fetchRoute()
    }
}

//MARK: - Network
extension CustomerMapViewController {
    func callCustomerMapDetails() {
        
        CustomerService().getMapOrderDetail(id: selectedOrderId) { result in
            switch result {
            case .success(let data):
                self.petsTopView.setupCustomerTopMapView(pets: data.pets, address: "")
                customerHomeSourceLong = data.customerHomePosition.long
                customerHomeSourcelat = data.customerHomePosition.lat
                customerCheckListArr = data.checklist
                print("checklist array",data.checklist)
                customerPointArr = data.points
                for i in 0..<customerCheckListArr.count {
                    if customerCheckListArr[i].dateStart != nil{
                        checkListStartArr.append(customerCheckListArr[i])
                    }
                }
                
                let camera = GMSCameraPosition.camera(withLatitude: customerHomeSourcelat, longitude: customerHomeSourceLong, zoom: 15.0)
                
                self.mapView.animate(to: camera)
                
                self.addBottomSheetView()
                self.fetchRoute()
            case .failure(let error):
                print(error)
            }
        }
    }
}
