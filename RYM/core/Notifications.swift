//
//  NotificationService.swift
//  RYM
//
//  Created by Yauheni Skiruk on 07/09/2022.
//

import UIKit
import UserNotifications

// MARK: - Notifications

final class Notifications: NSObject, UNUserNotificationCenterDelegate {

#if TEST

    // Only used for tests
    static var sharedNotifications: Notifications!

    // Public init
    override init() {
        super.init()
    }

#else

    static let shared = Notifications()

    func initialize() {
        requestAutorization()
        UNUserNotificationCenter.current().delegate = self
    }

#endif

    // MARK: - Properties
    let notificationCenter = UNUserNotificationCenter.current()

    // MARK: - Request permissions

    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else {
                print(error ?? "error")
                return
            }
            AppConfig.shared.notificationAccess = granted
        }
    }

    func unregisteredFromNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    // MARK: - Create Notification

    func scheduleNotification(remainderText: String, remainderId: String, currentWeekDay: Int, remainderDate: Date) {

        let content = UNMutableNotificationContent()
        content.title = "Medicine Remander"
        content.subtitle = remainderText
        content.sound = UNNotificationSound.default

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: remainderDate)
        let minutes = calendar.component(.minute, from: remainderDate)
        var components = DateComponents()
        components.day = currentWeekDay + 1
        components.hour = hour
        components.minute = minutes

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: remainderId, content: content, trigger: trigger)
        notificationCenter.add(request)
    }

    // MARK: - Delete Notifications
    func removePendingNotifications(IDs: [String]) {
        notificationCenter
            .removePendingNotificationRequests(withIdentifiers: IDs)
    }

    func permissionGranted(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }
}
