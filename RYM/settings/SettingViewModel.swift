//
//  SettingViewModel.swift
//  RYM
//
//  Created by Yauheni Skiruk on 20.09.22.
//

import Foundation
import SwiftUI
import CoreData

class SettingViewModel: ObservableObject {
    
    private var viewService: RemainderViewService
    private var contex: NSManagedObjectContext

    init(viewService: RemainderViewService, contex: NSManagedObjectContext) {
        self.viewService = viewService
        self.contex = contex
    }
    
    func turnOnNotifications() {
        self.viewService.turnOnAllNotifications(context: contex)
    }
    
    func turnOffNotifications() {
        Notifications.shared.removePendingNotifications(IDs: self.viewService.notificationsIds)
    }
    
    func deleteButtonPressed(contex: NSManagedObjectContext) {
        let alertBtnYes = AlertInfo.Button(title: "Yes", style: .destructive, action: {
            self.viewService.deleteAllData(context: contex)
            self.finishDeletionAlertPresent()
        })
        let alertBtnNo = AlertInfo.Button(title: "No", action: {})
        let alert = AlertInfo(title: "Delete all remainders?",
                              message: "By tapping YES you will remove all your data",
                              buttons: [ alertBtnYes, alertBtnNo ])
        HomePresenter.shared.show(alert: alert)
    }
    
    private func finishDeletionAlertPresent() {
        
        let alertBtn = AlertInfo.Button(title: "OK", action: {})
        let alert = AlertInfo(title: "All remainders are deleted",
                              message: nil,
                              buttons: [ alertBtn ])
        HomePresenter.shared.show(alert: alert)
    }
    
    func goToSettingAlertPresent() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        let alertButtonSettings = AlertInfo.Button(title: "Go to Settings") {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
            }
        }
        let alertButtonCancel = AlertInfo.Button(title: "Cancel", action: {})
        let alert = AlertInfo(title: "Notifications is turned of",
                              message: "Please go to settings and Turn ON notifications",
                              buttons: [ alertButtonCancel, alertButtonSettings ])
        HomePresenter.shared.show(alert: alert)
    }
    
}
