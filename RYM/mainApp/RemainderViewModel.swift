//
//  RemainderViewModel.swift
//  RYM
//
//  Created by Yauheni Skiruk on 05/09/2022.
//

import SwiftUI
import CoreData

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

    // MARK: Adding remainder to Database
    func addRemainder(context: NSManagedObjectContext) -> Bool {
        var remainder: MedicineRemainder?
        if let editRemainder = editRemainder {
            remainder = editRemainder
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
            // MARK: Shedule notifications
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

    // MARK: Done button status
    func doneStatus() -> Bool {
        let remainderStatus = isRemainderOn ? remainderText == "" : false

        if title == "" || weekDays.isEmpty || remainderStatus {
            return false
        }
         return true
    }

}
