//
//  UIVCExtension.swift
//  u92
//
//  Created by Anastasia Zhdanova on 4/9/19.
//  Copyright © 2019 Anastasia Zhdanova. All rights reserved.
//
// swiftlint:disable all


import UIKit

extension UIViewController {
    
    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    func showCustomBlur() {
        let blackoutView = UIView()
        blackoutView.tag = 1488
        blackoutView.backgroundColor = UIColor(red: 0.027, green: 0.059, blue: 0.141, alpha: 0.6)
        view.addSubview(blackoutView)
        blackoutView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func removeCustomBlur() {
        view.subviews.forEach {if $0.tag == 1488 { $0.removeFromSuperview()}}
    }

    func showAlert(title: String,
                   message: String? = nil,
                   singleAction: Bool = true,
                   leftButtonName: String? = "Cancel",
                   rightButtonName: String? = "Settings",
                   completionleftBtn: ((UIAlertAction) -> Void)? = nil,
                   completionrightBtn: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if singleAction {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: completionrightBtn)
            alert.addAction(okAction)
        } else {
            let cancelAction = UIAlertAction(title: leftButtonName, style: .default, handler: completionleftBtn)
            let settingstAction = UIAlertAction(title: rightButtonName,
                                                style: .default,
                                                handler: completionrightBtn)
            alert.addAction(cancelAction)
            alert.addAction(settingstAction)
        }
        
        self.present(alert, animated: true)
    }
    func presentImagePicker(_ imagePicker: UIImagePickerController = UIImagePickerController(),
                            delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        func actionHandler(_ pickerSourceType: UIImagePickerController.SourceType, _ action: UIAlertAction) {
            imagePicker.sourceType = pickerSourceType
            imagePicker.delegate = delegate
            imagePicker.mediaTypes = [pickerSourceType == .photoLibrary ? "public.image" : "public.movie"]
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true)
        }
        
//        view.addBlurOverlay()
        DispatchQueue.main.async {
            let actionSheetVC = UIAlertController(title: "Share file", message: nil, preferredStyle: .actionSheet)
            
            let video = UIAlertAction(title: "Video", style: .default) { action in
                actionHandler(.savedPhotosAlbum, action)
            }
            let photo = UIAlertAction(title: "Photo", style: .default) { action in
                actionHandler(.photoLibrary, action)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            [photo, video, cancel].forEach { actionSheetVC.addAction($0) }
            self.present(actionSheetVC, animated: true, completion: nil)
        }
    }
    // MARK: - Side Bar
    func addChildController(controller: UIViewController,
                            size: CGSize,
                            animationOrigin: CGPoint,
                            staticOrigin: CGPoint,
                            desiredColor: UIColor? = nil) {
        let blackView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: self.view.frame.origin.y),
                                             size: CGSize(width: (self.view.superview?.frame.size.width)!,
                                                          height: self.view.frame.size.height)))
        if let color = desiredColor {
            blackView.backgroundColor = color
            blackView.alpha = 0.35
        } else {
            blackView.backgroundColor = #colorLiteral(red: 0.4950264096, green: 0.495038569, blue: 0.4950320721, alpha: 1)
            blackView.alpha = 0.7
        }
        blackView.tag = 100
        self.navigationController?.view.addSubview(blackView)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blackView.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: self.view.widthAnchor)])
        self.navigationController?.addChild(controller)
        self.navigationController?.view.addSubview(controller.view)
        controller.didMove(toParent: self.navigationController!)
        controller.view.frame.size = size
        controller.view.frame.origin = staticOrigin
        UIView.animate(withDuration: 0.4) {
            controller.view.frame.origin = animationOrigin
        }
    }
    func removeChildVC () {
        UIView.animate(withDuration: 0.4) {
            self.view.frame.origin = CGPoint(x: -self.view.frame.size.width, y: 0 )
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            guard let childViews = self?.parent?.view.subviews else {return}
            for view in childViews where view.tag == 100 {
                    view.removeFromSuperview()
            }
            self?.willMove(toParent: nil)
            self?.view.removeFromSuperview()
            self?.removeFromParent()
        }
    }
     // MARK: - Hide keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        view.layoutIfNeeded()
    }
}
