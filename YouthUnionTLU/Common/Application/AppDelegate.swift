//
//  AppDelegate.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 08/03/2024.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    
    private static var sharedInstance: AppDelegate?
    static var shared: AppDelegate {
        return sharedInstance!
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AppDelegate.sharedInstance = self
        AppAppearance.setupAppearance()
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
        
        IQKeyboardManager.shared.enable = true
        
        return true
    }
}
