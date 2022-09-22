//
//  LaunchScreenView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import CoreData

// MARK: - Second screen of application (after Launch screen)
struct LaunchScreenView: View {
    weak var navigationController: UINavigationController?
    var viewContext: NSPersistentContainer
    let isFinishOnboarding = AppConfig.shared.isFinishOnboarding

    var body: some View {
        Color.blue
            .opacity(0.6)
            .ignoresSafeArea()
            .onAppear {
                showInitialView()
            }
            .environment(\.managedObjectContext, viewContext.viewContext)
    }

    /// Functuion that order what screen must be shown (onboarding or main screen)
    private func showInitialView() {
        if isFinishOnboarding {
            navigationController?.setViewControllers([HomeViewController(viewContex: viewContext)], animated: false)
        } else {
            let viewModel = OnboardingViewModel(navController: navigationController, viewContext: viewContext)
            navigationController?.setViewControllers(
                [UIHostingController(rootView: OnboardingView(viewModel: viewModel))], animated: false)
        }
    }
}
