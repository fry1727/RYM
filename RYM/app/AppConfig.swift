//
//  AppConfig.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI

final class AppConfig {

#if TEST
    // Only used for tests
    static var sharedInstance: AppConfig!

    override init() {
        super.init()
    }

#else
    static let shared = AppConfig()

#endif
    @AppStorage("isFinishOnboarding") var isFinishOnboarding = false
    @AppStorage("isNotificationAccess") var notificationAccess = false
}
