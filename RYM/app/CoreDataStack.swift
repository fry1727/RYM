//
//  CoreDataStack.swift
//  RYM
//
//  Created by Yauheni Skiruk on 13.09.22.
//

import Foundation
import CoreData

// MARK: Main class for work with Core Data
class CoreDataStack: NSObject {
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group..com.rym.new")!
        let storeURL = containerURL.appendingPathComponent("DataModel.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        
        let container = NSPersistentContainer(name: "RYM")
        container.persistentStoreDescriptions = [description]

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


