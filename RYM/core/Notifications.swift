//
//  NotificationService.swift
//  RYM
//
//  Created by Yauheni Skiruk on 07/09/2022.
//

import UIKit
import UserNotifications

// MARK: - Notifications
/// This is a class for working with Notification in Project
final class Notifications: NSObject, UNUserNotificationCenterDelegate {

#if TEST
    // Only used for tests
    static var sharedNotifications: Notifications!
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

    /**
     Call this function for showing reuqest for showing user a Notifications.
     - Iportant: acording via Apple GuideLines you can show request only 1 time
     */
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else {
                print(error ?? "error")
                return
            }
            AppConfig.shared.notificationAccess = granted
        }
    }

    // MARK: - Create Notification
    /**
     Function for creating local user notifications.
     */
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

    // MARK: - Delete notifications
    /**
     Function for deleting local user notifications by id
     */
    func removePendingNotifications(IDs: [String]) {
        notificationCenter
            .removePendingNotificationRequests(withIdentifiers: IDs)
    }

    /**
     Function for deleting all user's pending notifications
     */
    func unregisteredFromNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    // MARK: - Check permission for notifications
    /**
     Function for checking user permisin for showing notifications
     */
    func permissionGranted(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }
}
