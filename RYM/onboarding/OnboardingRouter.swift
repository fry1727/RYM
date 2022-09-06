//
//  OnboardingRouter.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import Foundation
import SwiftUI
import UIKit

final class OnboardingRouter: BaseRouter, BasePresenter {
    weak var navigationController: UINavigationController?

    init(navController: UINavigationController? = nil) {
        navigationController = navController
    }

    func swipeToBack(_ enabled: Bool) {
        guard let navController = navigationController as? NavigationController else { return }
        navController.isSwipeToBackEnabled = enabled
    }

    func setRootNavigation<V: View>(views: [V], animated: Bool = true) {
        let controllers = views.compactMap { UIHostingController(rootView: $0) }
        navigationController?.setViewControllers(controllers, animated: animated)
    }
}
