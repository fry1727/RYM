//
//  AppDelegate.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import CoreData
import FirebaseCore

// MARK: - Main class of application
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coreDataStack = CoreDataStack()
    let validator = SubscriptionReceiptValidator()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = NavigationController()

        let launchView = LaunchScreenView(navigationController: navigationController,
                                          viewContext: coreDataStack.persistentContainer)

        navigationController.setViewControllers([UIHostingController(rootView: launchView)], animated: false)
        navigationController.navigationBar.isHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        FirebaseApp.configure()
        SubscriptionService.shared.initialize()
        Notifications.shared.requestAutorization()
        validator.validateReceipt { isVip in
            AppConfig.shared.isVip = isVip
        }

        // MARK: - Customizing SearchBar
        UISearchBar.appearance().tintColor = .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .black

        return true
    }
    /// For update notification permissin status  
    func applicationDidBecomeActive(_ application: UIApplication) {
        Notifications.shared.permissionGranted { granted in
            AppConfig.shared.notificationAccess = granted
        }
    }
}
