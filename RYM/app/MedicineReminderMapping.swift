////
////  MedicineReminderMapping.swift
////  RYM
////
////  Created by Yauheni Skiruk on 28.10.22.
////
//
//import Foundation
//import CoreData
//// swiftlint:disable all
//class MedicineRemainderTransformationPolicy: NSEntityMigrationPolicy {
//
////    func changeData(notificationDate: Date) -> [Date] {
////        var arrayDaytes: [Date] = []
////        arrayDaytes.append(notificationDate)
////        return arrayDaytes
////    }
//
//    func changeData(old: Date) -> [Date] {
//        var arrayDaytes: [Date] = []
//               arrayDaytes.append(old)
//               return arrayDaytes
//    }
//
//    
//
////    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
////        if sInstance.entity.name == "MedicineRemainder" {
////            let color = sInstance.primitiveValue(forKey: "color") as! String
////            let dateAdded = sInstance.primitiveValue(forKey: "dateAdded") as! Date
////            let isRemainderOn = sInstance.primitiveValue(forKey: "isRemainderOn") as! Bool
////            let notificationDate = sInstance.primitiveValue(forKey: "notificationDate") as! [Date]
////            let notificationIDs = sInstance.primitiveValue(forKey: "notificationIDs") as! [String]
////            let remainderText = sInstance.primitiveValue(forKey: "remainderText") as! String
////            let title = sInstance.primitiveValue(forKey: "title") as! String
////            let weekDays = sInstance.primitiveValue(forKey: "weekDays") as? [String]
////        }
////    }
//
//}
//// swiftlint:enable all
