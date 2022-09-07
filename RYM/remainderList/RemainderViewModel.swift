//
//  RemainderViewModel.swift
//  RYM
//
//  Created by Yauheni Skiruk on 05/09/2022.
//

import SwiftUI
import CoreData
import UserNotifications

class RemainderViewModel: ObservableObject {
    
    // MARK: - New Remainder Properties
    @Published var addNewRemainder: Bool = false
    
    @Published var title: String = ""
    @Published var remainderColor: String = "Card-1"
    @Published var weekDays: [String] = []
    @Published var isRemainderOn: Bool = false
    @Published var remainderText: String = ""
    @Published var remainderDate: Date = Date()
    
    // MARK: Reminder Time Picker
    @Published var showTimePicker: Bool = false
    
    // MARK: Edit Remainder
    @Published var editRemainder: MedicineRemainder?
    
    // MARK: Notification access status
    @Published var notificationAccess: Bool = false
    
    func requestNotificationAccess() {
        UNUserNotificationCenter.current().requestAuthorization { status, _ in
            DispatchQueue.main.async {
                self.notificationAccess = status
            }
        }
    }
    
    // MARK: Adding remainder to Database
    func addRemainder(context: NSManagedObjectContext) -> Bool {
        var remainder: MedicineRemainder?
        if let editRemainder = editRemainder {
            remainder = editRemainder
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: editRemainder.notificationIDs ?? [])
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
            remainder.notificationIDs = sheduleNotifications()
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
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: editRemainder.notificationIDs ?? [])
            }
            context.delete(editRemainder)
            if let _ = try? context.save() {
                return true
            }
        }
        return false
    }
    
    // MARK: Erasing content
    func resetData() {
        title = ""
        remainderColor = "Card-1"
        weekDays = []
        isRemainderOn = false
        remainderText = ""
        remainderDate = Date()
        editRemainder = nil
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
        }
    }
    
    // MARK: Adding Notifications
    func sheduleNotifications() -> [String] {
        let content = UNMutableNotificationContent()
        content.title = "Medicine Remander"
        content.subtitle = remainderText
        content.sound = UNNotificationSound.default
        
        // MARK: Scheduling Ids
        var notificationsIds: [String] = []
        let calendar = Calendar.current
        let weekdaySymbols: [String] = calendar.weekdaySymbols
        for weekDay in weekDays {
            let id = UUID().uuidString
            let hour = calendar.component(.hour, from: remainderDate)
            let minutes = calendar.component(.minute, from: remainderDate)
            let day = weekdaySymbols.firstIndex { currentDay in
                return currentDay == weekDay
            } ?? -1
            if day != -1 {
                var components = DateComponents()
                components.day = day + 1
                components.hour = hour
                components.minute = minutes
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
                notificationsIds.append(id)
            }
        }
        return notificationsIds
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
