//
//  SettingViewModel.swift
//  RYM
//
//  Created by Yauheni Skiruk on 20.09.22.
//

import Foundation
import SwiftUI
import CoreData

// MARK: - ViewModel for setting
class SettingViewModel: ObservableObject {
    private var viewService: RemainderViewService
    let haptics = HapticsManager.shared

    init(viewService: RemainderViewService) {
        self.viewService = viewService
    }

    /// Function for turn on notidication and turn on config notification state
    func turnOnNotifications() {
        haptics.vibrate(for: .success)
        self.viewService.turnOnAllNotifications()
        AppConfig.shared.notificationsTurnOn = true
    }

    /// Function for delete all panding notification
    func turnOffNotifications() {
        Notifications.shared.removePendingNotifications(IDs: self.viewService.notificationsIds)
    }
    /// Function for delete all data from Core Data
    func deleteButtonPressed() {
        let alertBtnYes = AlertInfo.Button(title: "Yes", style: .destructive, action: {
            self.viewService.deleteAllData()
            self.finishDeletionAlertPresent()
        })
        let alertBtnNo = AlertInfo.Button(title: "No", action: {})
        let alert = AlertInfo(title: "Delete all reminders?",
                              message: "By tapping YES you will remove all your data",
                              buttons: [ alertBtnYes, alertBtnNo ])
        HomePresenter.shared.show(alert: alert)
    }

    /// Function fow showing alert for deleting all data
    private func finishDeletionAlertPresent() {
        let alertBtn = AlertInfo.Button(title: "OK", action: {})
        let alert = AlertInfo(title: "All reminders are deleted",
                              message: nil,
                              buttons: [ alertBtn ])
        HomePresenter.shared.show(alert: alert)
    }

    /// Function fow showing alert for turn on a notification from setting
    func goToSettingAlertPresent() {
        haptics.vibrate(for: .warning)
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        let alertButtonSettings = AlertInfo.Button(title: "Go to Settings") {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
            }
        }
        let alertButtonCancel = AlertInfo.Button(title: "Cancel", action: {})
        let alert = AlertInfo(title: "Notifications is turned off",
                              message: "Please go to settings and turn on notifications",
                              buttons: [ alertButtonCancel, alertButtonSettings ])
        HomePresenter.shared.show(alert: alert)
    }

    /// Function fow showing alert for turning off notifications
    func turnOffNotificationAlertPresent() {
        haptics.vibrate(for: .warning)
        let alertButtonYes = AlertInfo.Button(title: "Yes") {
            self.turnOffNotifications()
            AppConfig.shared.notificationsTurnOn = false
        }
        let alertButtonNo = AlertInfo.Button(title: "No", action: {
            AppConfig.shared.notificationsTurnOn = true
        })
        let alert = AlertInfo(title: "Do you realy want to turn off notifications?",
                              message: nil,
                              buttons: [ alertButtonYes, alertButtonNo ])
        HomePresenter.shared.show(alert: alert)
    }
}
