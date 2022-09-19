//
//  AppDelegate.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = NavigationController()

        let launchView = LaunchScreenView(navigationController: navigationController, viewContext: coreDataStack.persistentContainer)

        navigationController.setViewControllers([UIHostingController(rootView: launchView)], animated: false)
        navigationController.navigationBar.isHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        Notifications.shared.requestAutorization()

        return true
    }
}
