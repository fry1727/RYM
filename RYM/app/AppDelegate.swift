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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = NavigationController()
        let launchView = LaunchScreenView(navigationController: navigationController, viewContext: persistentContainer)

        navigationController.setViewControllers([UIHostingController(rootView: launchView)], animated: false)
        navigationController.navigationBar.isHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "RYM")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
