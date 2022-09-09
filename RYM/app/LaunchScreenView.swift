//
//  LaunchScreenView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import CoreData

struct LaunchScreenView: View {
    weak var navigationController: UINavigationController?
    var viewContext: NSPersistentContainer

    var body: some View {
        Color.blue
            .opacity(0.6)
            .ignoresSafeArea()
            .onAppear {
                showInitialView()
            }
            .environment(\.managedObjectContext, viewContext.viewContext)
    }

    private func showInitialView() {
        if AppConfig.shared.isFinishOnboarding {
            navigationController?.setViewControllers([HomeViewController(viewContex: viewContext)], animated: false)
        } else {
            let viewModel = OnboardingViewModel(navController: navigationController, viewContext: viewContext)
            navigationController?.setViewControllers(
                [UIHostingController(rootView: OnboardingView(viewModel: viewModel))], animated: false)
        }
    }
}
