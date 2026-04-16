//
//  BaseViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 23.06.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//
import UIKit
enum AlertType {
    case error
    case unAuthroized
}
class BaseViewController: UIViewController {

    //MARK: - UIProperties
    
    private lazy var alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.delegate = self
        return view
    }()
        
    var activityView: UIActivityIndicatorView?
    let blankView = UIView()
    let clearView = UIView()
    //MARK: - Properties
    
    private var isOrder = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Setup error
    
    func setupErrorAlert(error: Error) {
        if let error = error as? ErrorResponse {
            if error.localizedDescription.contains("veterinarians.0.Veterinarian phone number is invalid") {
                self.alertView.setupAlert(description: "Veterinarian number is invalid", alertType: .error)
            } else if error.localizedDescription.contains("Unauthorized") {
                
                self.alertView.setupAlert(description: "Your session has been expired, Please login again.", alertType: .unAuthroized)
            } else {
                self.alertView.setupAlert(description: error.localizedDescription, alertType: .error)
            }
        } else {
            self.alertView.setupAlert(description: error.localizedDescription, alertType: .error)
        }
        self.showCustomBlur()
        self.view.addSubview(self.alertView)
        self.alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupWarning(alert: String, isOrders: Bool) {
        isOrder = isOrders
        self.alertView.setupAlert(description: alert, alertType: .error)
        self.showCustomBlur()
        self.view.addSubview(self.alertView)
        self.alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Setup activityView
    
    func showActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        }
        activityView?.layer.zPosition = 9999
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator() {
        activityView?.stopAnimating()
    }
    
    func showClearView() {
        clearView.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        clearView.isHidden = false
        self.view.addSubview(clearView)
        clearView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.bottom.equalTo(view)
        }
        showActivityIndicator()
    }
        
    func hideClearView() {
        clearView.isHidden = true
        clearView.removeFromSuperview()
        hideActivityIndicator()
    }
    
    func showView() {
        blankView.backgroundColor = .white
        blankView.layer.zPosition = 9998
        self.view.addSubview(blankView)
        blankView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.bottom.equalTo(view)
        }
        showActivityIndicator()
    }
        
    func hideView() {
        blankView.isHidden = true
        blankView.removeFromSuperview()
        hideActivityIndicator()
    }
}

//MARK: - CustomAlertViewDelegate

extension BaseViewController: CustomAlertViewDelegate {
    func okButtonTouched(alertType: AlertType) {
        if alertType == .error {
            if isOrder {
                let vc = CustomerDashboardTabBarController()
                vc.selectedIndex = 1
                vc.modalPresentationStyle = .currentContext
                self.present(vc, animated: true, completion: nil)
            } else {
                self.removeCustomBlur()
                self.alertView.removeFromSuperview()
            }
        } else if alertType == .unAuthroized {
            DBManager.shared.removeAccessToken()
            DBManager.shared.saveStatus(0)
            DBManager.shared.removeUserRole()
            let vc = UINavigationController(rootViewController: AuthorizationVC())
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        }
    }
}
