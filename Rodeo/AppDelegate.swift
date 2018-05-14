//
//  AppDelegate.swift
//  Rodeo
//
//  Created by Admin on 15/04/18.
//  Copyright © 2018 AstroWorld. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import Toast_Swift

var appInstance: AppDelegate!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        appInstance = self
        
        FirebaseApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        
        if Auth.auth().currentUser != nil {
            window?.rootViewController = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeNVC")
        }
        
        ToastManager.shared.position = .top
        
        return true
    }

    
    func hideLoader()
    {
        self.window?.isUserInteractionEnabled = true
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func showLoader()
    {
        self.window?.isUserInteractionEnabled = false
        let activityData = ActivityData(size: CGSize(width: 40, height: 40), message: "", messageFont: nil, type: NVActivityIndicatorType.ballPulse, color: UIColor.red, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        self.window?.isUserInteractionEnabled = false
    }
}

