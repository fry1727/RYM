//
//  NotificationService.swift
//  RYM
//
//  Created by Yauheni Skiruk on 07/09/2022.
//

import UIKit
import UserNotifications

//MARK: - Notifications

final class Notifications: NSObject, UNUserNotificationCenterDelegate {

    static let shared = Notifications()

    func initialize() {
        requestAutorization()
        UNUserNotificationCenter.current().delegate = self

    }


    //MARK: - Properties

    let notificationCenter = UNUserNotificationCenter.current()

    //MARK: - Request permissions

    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
        }
    }

    func unregisteredFromNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    func scheduleNotifications() {
        scheduleNotification(notificationType: "first", categoryIdentifier: "User Action1",
                             weekday: 3, hour: 16)            //every Thuesday at 16.00
        scheduleNotification(notificationType: "second", categoryIdentifier: "User Action2",
                             weekday: 6, hour: 13)             // every Friday at 13.00
    }

    //MARK: - Create Notification

    func scheduleNotification(notificationType: String, categoryIdentifier: String, weekday: Int, hour: Int) {
        let content = UNMutableNotificationContent()
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.weekday = weekday
        dateComponents.hour = hour
        content.title = "Take care about your privacy!"
        content.body = "Go to customize your privacy settings"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifier
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let identifire = "Local Notification"
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(
            identifier: categoryIdentifier,
            actions: [deleteAction],
            intentIdentifiers: [],
            options: [])
        notificationCenter.setNotificationCategories([category])
    }

    func permissionGranted(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }

    func getPermissionStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

}
