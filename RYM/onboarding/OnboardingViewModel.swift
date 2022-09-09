//
//  OnboardingViewModel.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import CoreData

final class OnboardingViewModel: ObservableObject {
    let router: OnboardingRouter
    let viewContext: NSPersistentContainer

    init(navController: UINavigationController? = nil, viewContext: NSPersistentContainer) {
        router = OnboardingRouter(navController: navController)
        self.viewContext = viewContext
    }

    func loginUser() {
        AppConfig.shared.isFinishOnboarding = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.router.swipeToBack(true)
            if let viewContext = self?.viewContext {
            self?.router.navigationController?.setViewControllers(
                [HomeViewController(viewContex: viewContext)], animated: true)
            }
        }
    }
}
