//
//  MapViewController.swift
//  p103-customer
//
//  Created by SOTSYS371 on 24/05/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import FittedSheets

protocol MapDelegate {
    func fetchRoute()
}

protocol MapLocationAccess {
    func getOrderDetails()
}

struct MarkerStruct {
    let name: String
    let lat: CLLocationDegrees
    let long: CLLocationDegrees
}


class MapViewController: BaseViewController, GMSMapViewDelegate {

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
    
    //MARK: - Properties:
    private var mapView = GMSMapView()
    private let locationManager = CLLocationManager()
    var id = String()
    var service: ServiceId?
    var distanceInMeter: Float?
    var distanceInMiles: Float?
    var tabBarHeight = 0
    var delegate: EmployeeMapDelegate?
    var mapMarkers : [GMSMarker] = []
 
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isEmployeeBottomSheetAdded = false
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        LocationManager.sharedInstance.mapAccessDelegate = self
        setupLayouts()
        LocationManager.sharedInstance.startUpdatingLocation()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: true) {
        }
    }
}

//MARK: - BottomSheet Setup
extension MapViewController {
    func addBottomSheetView(scrollable: Bool? = true) {
        tabBarHeight = 0
        let bottomSheetVC = MapBottomSheetViewController()
        mapStatArr.removeAll()
        if self.view.frame.height < 700 {
            tabBarHeight = 49
        } else {
            tabBarHeight = 70
        }
        
        bottomSheetVC.tabBarHeight = tabBarHeight
        let coordinates = CLLocationCoordinate2D(latitude: customerHomeSourcelat, longitude: customerHomeSourceLong)
        if distanceInMiles ?? 0.0 > 150.0 {
            
            let camera = GMSCameraPosition.camera(withLatitude: (customerHomeSourcelat), longitude: (customerHomeSourceLong), zoom: 15.0)
            self.mapView.animate(to: camera)
            let useInlineMode = view != nil
            Constant.sheet = SheetViewController(
                controller: bottomSheetVC,
                sizes: [.fixed(CGFloat(80 + tabBarHeight))],
                options: SheetOptions(useInlineMode: useInlineMode))
            Constant.sheet?.allowPullingPastMaxHeight = false
            Constant.sheet?.allowPullingPastMinHeight = false

            Constant.sheet?.dismissOnPull = false
            Constant.sheet?.dismissOnOverlayTap = false
            Constant.sheet?.overlayColor = UIColor.clear

            Constant.sheet?.contentViewController.view.layer.shadowColor = UIColor.black.cgColor
            Constant.sheet?.contentViewController.view.layer.shadowOpacity = 0.1
            Constant.sheet?.contentViewController.view.layer.cornerRadius = 32
            Constant.sheet?.allowGestureThroughOverlay  = true
            bottomSheetVC.goToDestinationLabel.isHidden = false
            bottomSheetVC.stepTblView.isHidden = true
        } else {
            let duration = 0.5
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            
//            let coordinates = CLLocationCoordinate2D(latitude: customerHomeSourcelat, longitude: customerHomeSourceLong)
//            let marker = GMSMarker()
//            marker.position = coordinates
//            marker.icon = UIImage(named: "daycareImage")
//            marker.map = mapView
            let camera = GMSCameraPosition.camera(withLatitude: (customerHomeSourcelat), longitude: (customerHomeSourceLong), zoom: 15.0)
            self.mapView.animate(to: camera)
            
            let marker = GMSMarker()
            marker.position = coordinates
            marker.icon = UIImage(named: "daycareImage")
            marker.map = mapView
            
            CATransaction.commit()
            
            
            let height = 220 + tabBarHeight
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
            Constant.sheet?.contentViewController.view.layer.cornerRadius = 32
            Constant.sheet?.allowGestureThroughOverlay = true
            bottomSheetVC.goToDestinationLabel.isHidden = true
            bottomSheetVC.stepTblView.isHidden = false
            mapStatArr.append(.topView)
        }
            bottomSheetVC.id = id
            bottomSheetVC.mapDelegate = delegate
            bottomSheetVC.service = service
            bottomSheetVC.delegate = self
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
//MARK: - Setup Layout

extension MapViewController {
    
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

//MARK: - Network
extension MapViewController: MapLocationAccess {
    func getOrderDetails() {
        showActivityIndicator()
        EmployeeService().getCurrentMapOrderDetails(id: id) { [self] result in
            print("Employee Map Details", result)
            switch result {
            case .success(let details):
                self.petsTopView.setupTopMapView(pets: details.pets, address: details.homeAddress)
                let userHomeLatitude = details.customerHomePosition.lat
                let userHomeLongitude = details.customerHomePosition.long
                LocationManager.sharedInstance.lastKnownLongitude = userHomeLongitude
                LocationManager.sharedInstance.lastKnownLatitude = userHomeLatitude
                customerHomeSourcelat = userHomeLatitude
                customerHomeSourceLong = userHomeLongitude
              
                let coordinate₀ = CLLocation(latitude: userHomeLatitude, longitude: userHomeLongitude)
                let coordinate₁ = CLLocation(latitude: LocationManager.sharedInstance.latitude , longitude: LocationManager.sharedInstance.longitude)
                distanceInMeter = Float(coordinate₁.distance(from: coordinate₀))
                print("distanceInMeter \(String(describing: self.distanceInMeter))")
                distanceInMiles = (distanceInMeter ?? 0.0) * 0.000621371
                isEmployeeBottomSheetAdded = true
                checkListArray = details.checklist
                pointsArr = details.points
              
                if pointsArr.count > 0 {
                    LocationManager.sharedInstance.latitude = pointsArr.last?.lat ?? 0.0
                    LocationManager.sharedInstance.longitude = pointsArr.last?.long ?? 0.0
                } else  {
                    LocationManager.sharedInstance.longitude = userHomeLongitude
                    LocationManager.sharedInstance.latitude = userHomeLatitude
                }

                self.fetchRoute()
                addBottomSheetView()
                self.hideActivityIndicator()

            case .failure(let error):
                self.setupErrorAlert(error: error)
                self.hideActivityIndicator()
            }
        }
    }
}
//MARK: - Draw Map Path
extension MapViewController {
    func drawPath(from polyStr: String){
        self.mapView.clear()
        self.mapMarkers.removeAll()
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = UIColor(hexString: "#860000")
        polyline.map = mapView// Google MapView
        
        
            if pointsArr.count > 0 {
                for i in 0..<pointsArr.count {
                    let position = CLLocationCoordinate2D(latitude: pointsArr[i].lat ?? 0.0, longitude: pointsArr[i].long ?? 0.0)
                    let locationmarker = GMSMarker(position: position)
                    let customView = CustomMarker.showAlert(title: checkListArray[i].name)
                    locationmarker.icon = customView.asImage(view: customView)
                    locationmarker.map = mapView
                    mapMarkers.append(locationmarker)
                }
            }
    }
}
// MARK: - MapDelegate
extension MapViewController : MapDelegate {
    func fetchRoute() {
            let session = URLSession.shared
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(customerHomeSourcelat),\(customerHomeSourceLong)&destination=\(LocationManager.sharedInstance.latitude),\(LocationManager.sharedInstance.longitude)&sensor=false&mode=driving&key=\(googleApiKey)")!
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
                
                print(" Total Number of Routes",routes.count)
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


//MARK: - UIView
extension UIView {

    func asImage(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.backgroundColor = CGColor.init(gray: 0, alpha: 0)
            
            layer.render(in: rendererContext.cgContext)
        }
    }
}
