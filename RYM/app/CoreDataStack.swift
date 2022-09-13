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
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "RYM")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}


