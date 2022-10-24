//
//  HomeRouter.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import Foundation
import SwiftUI

// MARK: - Basic class for navigation
final class HomeRouter: BaseRouter, ObservableObject {
    static let shared = HomeRouter()

    weak var navigationController: UINavigationController?

    private init() {}

/// Function for reset to root all screens (used when logout and etc)
    func reset() {
        popToRoot()
        dissmisToRoot()
    }
}
