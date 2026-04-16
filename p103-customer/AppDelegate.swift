//
//  AppDelegate.swift
//  p103-customer
//
//  Created by Yaroslav on 8/21/19.
//  Copyright © 2019 PULS Software. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
#if DEBUG
import FLEX
#endif
import FirebaseCore
import FirebaseMessaging
import UserNotifications

let googleApiKey = "AIzaSyDnBiLphfhh8LzSPg6U79dWF616u8AOcuY"

//let googleApiKey = "AIzaSyA4yF4dChynQH6jehfQ5xYWBcgfsF8te4U"


let attrs = [
  NSAttributedString.Key.font: R.font.aileronBold(size: 18)!
]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        PresentManager.shared.presentStartScreen()
   
        self.flexSetUp()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)
        
        FirebaseApp.configure()
        self.registerForPushNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0

        return true
    }
    
    
    // MARK: Deeplinks
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let parameters = url.params()
        if url.path == "/forgot-password/accept" {
            PresentManager.shared.presentForgotPasswordFlow(code: parameters)
        }
        return true
    }
         
    func flexSetUp() {
        let gestureForFlex = UITapGestureRecognizer(target: self, action: #selector(self.showFlex))
        gestureForFlex.numberOfTouchesRequired = 2
        gestureForFlex.numberOfTapsRequired = 2
        self.window?.addGestureRecognizer(gestureForFlex)
    }
    
    @objc func showFlex() {
        #if DEBUG
        FLEXManager.shared.showExplorer()
        #endif
    }
    
}
