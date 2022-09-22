//
//  AppConfig.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
/// Config for specify and controle some functionalities as onboarding and notodocations
final class AppConfig: ObservableObject {

#if TEST
    // MARK: - This methods used only for tests
    static var sharedInstance: AppConfig!

    override init() {
        super.init()
    }
    // MARK: - Main functionality
#else
    static let shared = AppConfig()

#endif
    /// Defines user onboarding complition status
    @AppStorage("isFinishOnboarding") var isFinishOnboarding = false
    /// Defines user notification permission granted status
    @AppStorage("isNotificationAccess") var notificationAccess = false
    /// Defines user notification permission turn on/off status
    @AppStorage("notificationsTurnOn") var notificationsTurnOn = true
}
