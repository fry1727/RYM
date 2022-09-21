//
//  CoreDataStack.swift
//  RYM
//
//  Created by Yauheni Skiruk on 13.09.22.
//

import Foundation
import CoreData


class CoreDataStack: NSObject {

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


