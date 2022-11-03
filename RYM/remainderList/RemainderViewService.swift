//
//  RemainderViewModel.swift
//  RYM
//
//  Created by Yauheni Skiruk on 05/09/2022.
//

import SwiftUI
import CoreData
import WidgetKit

class RemainderViewService: ObservableObject {
    // MARK: All remainders
    @Published var remainders: [MedicineRemainder] = []

    // MARK: - Fetching Data from Core Data and setting content
    init(context: NSManagedObjectContext) {
        self.context = context
        let fetchRequest = NSFetchRequest<MedicineRemainder>(entityName: "MedicineRemainder")
        do {
            remainders = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }

        for remainder in remainders {
            if remainder.notificationDate != nil && remainder.notificationDate != Date(timeIntervalSince1970: 0) {
                if let notificationDate = remainder.notificationDate {
                    remainder.notificationDates?.append(notificationDate)
                    remainder.notificationDate = Date(timeIntervalSince1970: 0)
                    if let _ = try? context.save() {
                    }
                }
            }
        }
    }

    // MARK: - Working with data from Core Data
    private var context: NSManagedObjectContext

    // MARK: - New Remainder Properties
    @Published var addNewRemainder: Bool = false

    @Published var title: String = ""
    @Published var remainderColor: String = "Card-1"
    @Published var weekDays: [String] = []
    @Published var isRemainderOn: Bool = false
    @Published var remainderText: String = ""
    @Published var remainderDate: Date = Date()
    @Published var reminderDates: [Date] = []

    // MARK: Reminder Time Picker
    @Published var showTimePicker = false

    // MARK: Setting presenter
    @Published var settingPresented = false

    // MARK: Edit Remainder
    @Published var editRemainder: MedicineRemainder?

    // MARK: Notification access status
    @Published var notificationAccess: Bool = AppConfig.shared.notificationAccess

    var notificationsIds: [String] = []

    let haptics = HapticsManager.shared

    // MARK: Adding remainder to Database
    func addRemainder() -> Bool {
        var remainder: MedicineRemainder?
        if let editRemainder = editRemainder {
            remainder = editRemainder
            remainder?.notificationDate = Date()
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
        remainder.dateAdded = Date()
        remainder.notificationDate = remainderDate
        remainder.notificationIDs = []
        remainder.notificationDates = reminderDates

        if isRemainderOn {
            sheduleNotificationsAndCreateIds()
            remainder.notificationIDs = notificationsIds
            if editRemainder == nil {
                remainders.append(remainder)
            }
            if let _ = try? context.save() {
                haptics.vibrate(for: .success)
                WidgetCenter.shared.reloadTimelines(ofKind: "com_rym_widget")
                return true
            } else {
                remainders.removeAll(where: { $0.id == remainder.id})
                remainders.append(remainder)
            }
        } else {
            if editRemainder == nil {
                remainders.append(remainder)
            } else {
                remainders.removeAll(where: { $0.id == remainder.id})
                remainders.append(remainder)
            }
            if let _ = try? context.save() {
                haptics.vibrate(for: .success)
                WidgetCenter.shared.reloadTimelines(ofKind: "com_rym_widget")
                return true
            }
        }
        return false
    }

    // MARK: Deleting medicineRemainders from Database
    func deleteRemainder() -> Bool {
        if let editRemainder = editRemainder {
            if editRemainder.isRemainderOn {
                UNUserNotificationCenter.current()
                    .removePendingNotificationRequests(withIdentifiers: editRemainder.notificationIDs ?? [])
            }
            remainders.removeAll(where: { $0.id == editRemainder.id })
            context.delete(editRemainder)
            haptics.vibrate(for: .error)
            if let _ = try? context.save() {
                WidgetCenter.shared.reloadTimelines(ofKind: "com_rym_widget")
                return true
            }
        }
        return false
    }

    // MARK: Delete ALL data
    func deleteAllData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
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
            WidgetCenter.shared.reloadTimelines(ofKind: "com_rym_widget")
            self.remainders = []
            self.notificationsIds = []
            do {
                haptics.vibrate(for: .error)
                try managedContext.execute(deleteAllEntities)
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Function for turn on all notifications
    func turnOnAllNotifications() {
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
                            for remDay in reminderDates {
                                Notifications.shared.scheduleNotification(remainderText: remainderText,
                                                                          remainderId: id,
                                                                          currentWeekDay: day,
                                                                          remainderDate: remDay)
                                notificationsIds.append(id)
                            }

                        }
                    }
                }
            }
        }
    }

    // MARK: Erasing content
    func resetData() {
        DispatchQueue.main.async {
            self.title = ""
            self.remainderColor = "Card-1"
            self.weekDays = []
            self.isRemainderOn = false
            self.remainderText = ""
            self.remainderDate = Date()
            self.editRemainder = nil
            self.reminderDates = []
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "com_rym_widget")
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
//            remainderDate = editRemainder.notificationDate ?? Date()
            notificationsIds = editRemainder.notificationIDs ?? []
            reminderDates = editRemainder.notificationDates ?? []
        }
    }

    // MARK: Adding Notifications
    func sheduleNotificationsAndCreateIds() {
        let calendar = Calendar.current
        let weekdaySymbols: [String] = calendar.shortStandaloneWeekdaySymbols
        for weekDay in weekDays {
            let id = UUID().uuidString

            let day = weekdaySymbols.firstIndex { currentDay in
                return currentDay == weekDay } ?? -1
            if day != -1 {
                for remainDate in reminderDates {
                    Notifications.shared.scheduleNotification(remainderText: remainderText,
                                                              remainderId: id,
                                                              currentWeekDay: day,
                                                              remainderDate: remainDate)
                    notificationsIds.append(id)
                }
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
