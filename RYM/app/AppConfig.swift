//
//  AppConfig.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI

final class AppConfig {
    static let shared = AppConfig()

    @AppStorage("isFinishOnboarding") var isFinishOnboarding = true
    @AppStorage("isNotificationAccess")var notificationAccess = false
}
