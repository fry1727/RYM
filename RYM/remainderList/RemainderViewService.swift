//
//  RemainderViewModel.swift
//  RYM
//
//  Created by Yauheni Skiruk on 05/09/2022.
//

import SwiftUI
import CoreData

class RemainderViewService: ObservableObject {
    
    // MARK: - New Remainder Properties
    @Published var addNewRemainder: Bool = false
    
    @Published var title: String = ""
    @Published var remainderColor: String = "Card-1"
    @Published var weekDays: [String] = []
    @Published var isRemainderOn: Bool = false
    @Published var remainderText: String = ""
    @Published var remainderDate: Date = Date()
    
    // MARK: Reminder Time Picker
    @Published var showTimePicker = false
    
    //MARK: Setting presenter
    @Published var settingPresented = false
    
    // MARK: Edit Remainder
    @Published var editRemainder: MedicineRemainder?
    
    // MARK: Notification access status
    @Published var notificationAccess: Bool = AppConfig.shared.notificationAccess
    
    var notificationsIds: [String] = []
    
    // MARK: Adding remainder to Database
    func addRemainder(context: NSManagedObjectContext) -> Bool {
        var remainder: MedicineRemainder?
        if let editRemainder = editRemainder {
            remainder = editRemainder
            Notifications.shared.removePendingNotifications(IDs: remainder?.notificationIDs ?? [])
        } else {
            remainder = MedicineRemainder(context: context)
        }
        guard let remainder = remainder else {
            return false
        }
        
        remainder.title = title
        remainder.color = remainderColor
        remainder.weekDays = weekDays
        remainder.isRemainderOn = isRemainderOn
        remainder.remainderText = remainderText
        remainder.notificationDate = remainderDate
        remainder.notificationIDs = []
        
        if isRemainderOn {
            sheduleNotificationsAndCreateIds()
            remainder.notificationIDs = notificationsIds
            if let _ = try? context.save() {
                return true
            }
        } else {
            if let _ = try? context.save() {
                return true
            }
        }
        return false
    }
    
    // MARK: Deleting medicineRemainders from Database
    func deleteRemainder(context: NSManagedObjectContext) -> Bool {
        if let editRemainder = editRemainder {
            if editRemainder.isRemainderOn {
                UNUserNotificationCenter.current()
                    .removePendingNotificationRequests(withIdentifiers: editRemainder.notificationIDs ?? [])
            }
            context.delete(editRemainder)
            if let _ = try? context.save() {
                return true
            }
        }
        return false
    }
    
    // MARK: Delete ALL data
    func deleteAllData(context: NSManagedObjectContext) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let managedContext = appDelegate.coreDataStack.persistentContainer.viewContext
            let deleteAllEntities = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "MedicineRemainder"))
            
            Notifications.shared.removePendingNotifications(IDs: notificationsIds)
            var remainders: [MedicineRemainder] = []
            let fetchRequest = NSFetchRequest<MedicineRemainder>(entityName: "MedicineRemainder")
            do {
                remainders = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
            
            for remainder in remainders {
                context.delete(remainder)
            }
            self.notificationsIds = []
            do {
                try managedContext.execute(deleteAllEntities)
            }
            catch {
                print(error)
            }
        }
    }
    
    //MARK: - Function for turn on all notifications
    func turnOnAllNotifications(context: NSManagedObjectContext) {
        var remainders: [MedicineRemainder] = []
        let fetchRequest = NSFetchRequest<MedicineRemainder>(entityName: "MedicineRemainder")
        do {
            remainders = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
        for remainder in remainders {
            if remainder.isRemainderOn {
                let calendar = Calendar.current
                let weekdaySymbols: [String] = calendar.weekdaySymbols
                if let remainderWeekdays = remainder.weekDays {
                    for weekDay in remainderWeekdays {
                        let id = UUID().uuidString
                        
                        let day = weekdaySymbols.firstIndex { currentDay in
                            return currentDay == weekDay } ?? -1
                        if day != -1 {
                            Notifications.shared.scheduleNotification(remainderText: remainderText,
                                                                      remainderId: id,
                                                                      currentWeekDay: day,
                                                                      remainderDate: remainderDate)
                            notificationsIds.append(id)
                        }
                    }
                }
            }
        }
        
    }
    
    // MARK: Erasing content
    func resetData() {
        self.title = ""
        self.remainderColor = "Card-1"
        self.weekDays = []
        self.isRemainderOn = false
        self.remainderText = ""
        self.remainderDate = Date()
        self.editRemainder = nil
        self.notificationsIds = []
    }
    
    // MARK: Restoring editing data
    func restoreEditingData() {
        if let editRemainder = editRemainder {
            title = editRemainder.title ?? ""
            remainderColor = editRemainder.color ?? "Card-1"
            weekDays = editRemainder.weekDays ?? []
            isRemainderOn = editRemainder.isRemainderOn
            remainderText = editRemainder.remainderText ?? ""
            remainderDate = editRemainder.notificationDate ?? Date()
            notificationsIds = editRemainder.notificationIDs ?? []
        }
    }
    
    // MARK: Adding Notifications
    func sheduleNotificationsAndCreateIds() {
        let calendar = Calendar.current
        let weekdaySymbols: [String] = calendar.weekdaySymbols
        for weekDay in weekDays {
            let id = UUID().uuidString
            
            let day = weekdaySymbols.firstIndex { currentDay in
                return currentDay == weekDay } ?? -1
            if day != -1 {
                Notifications.shared.scheduleNotification(remainderText: remainderText,
                                                          remainderId: id,
                                                          currentWeekDay: day,
                                                          remainderDate: remainderDate)
                notificationsIds.append(id)
            }
        }
    }
    
    // MARK: Done button status
    func doneStatus() -> Bool {
        let remainderStatus = isRemainderOn ? remainderText == "" : false
        if title == "" || weekDays.isEmpty || remainderStatus {
            return false
        }
        return true
    }
    
}
