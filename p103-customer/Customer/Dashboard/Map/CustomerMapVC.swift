//
//  MapVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 08.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

enum CardState {
    case expanded
    case collapsed
}

class CustomerMapVC: BaseViewController {
    
    // MARK: - UI Property
    
    private let mapView = GMSMapView()
    

    private let locationManager = CLLocationManager()
    let bottomSheetVC = EmpBottomMapView()
    private var topSafeArea: CGFloat = 0
    private var bottomSafeArea: CGFloat = 0
    private let petViewHeight: CGFloat = 76
    private let cardVCInset: CGFloat = 30
    private let cardHandleAreaHeight:CGFloat = 135
    
    private var cardVisible = false
    private var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted:CGFloat = 0
    
    private var tabBarHeight = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        locationManager.delegate = self

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.startUpdatingLocation()
        
        setupLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
    }
    // MARK: - Private functions
    
    private func asd() -> CGFloat {
        
        return self.view.frame.height - topSafeArea - bottomSafeArea - petViewHeight - cardVCInset
    }

    func setupCard() {

        
      

        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        // 3- Adjust bottomSheet frame and initial position.
        let height = view.frame.height
        let width  = view.frame.width
//        bottomSheetVC.view.frame = CGRectMake(0, self.view.frame.maxY, width, height)
        
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight  -  CGFloat(tabBarHeight), width: self.view.bounds.width, height:  asd())
    }
    
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:

            break
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.bottomSheetVC.view.frame.origin.y = self.view.frame.height - self.asd() - (self.tabBarController?.tabBar.frame.height ?? 0)
                case .collapsed:
                    self.bottomSheetVC.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight - (self.tabBarController?.tabBar.frame.height ?? 0)
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

//MARK: - Setup Layout

extension CustomerMapVC {
    
    private func setupLayouts() {
        view.addSubviews([mapView])
        mapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        

    }
}

//MARK: - CLLocationManagerDelegate

extension CustomerMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.requestLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
        let location = locations.last

        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)

        self.mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - PetsTopViewDelegate

extension CustomerMapVC: PetsTopViewDelegate {
    func stateButtonTouched(open: Bool) {
        if open {

        } else {

        }
    }
}
