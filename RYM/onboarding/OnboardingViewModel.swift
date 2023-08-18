//
//  OnboardingViewModel.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import CoreData

// MARK: - Onboarding view model
final class OnboardingViewModel: ObservableObject {
    let router: OnboardingRouter
    let viewContext: NSPersistentContainer
    let subscriptionsService = SubscriptionService.shared
    var subscriptionsPresenter = SubscriptionsPresenter.shared
    
    init(navController: UINavigationController? = nil, viewContext: NSPersistentContainer) {
        router = OnboardingRouter(navController: navController)
        self.viewContext = viewContext
    }

    /// Function for changing isFinishOnboarding state and go to main screen
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

// MARK: - Subscriptions on registration

extension OnboardingViewModel {
    func showPaywallOnRegistration() {
        let view = PaywallView(onCloseClicked: onCloseClicked,
                               onRestoreClicked: { self.onRestoreClickedOnRegistration() },
                               onPurchaseClicked: { self.onPurchaseClickedOnRegistration($0) })
        router.push(view: view)
    }

    private func onCloseClicked() {
        self.loginUser()
    }

    private func onRestoreClickedOnRegistration() {
        self.subscriptionsPresenter.isLoading = true
        subscriptionsService.restorePurchases { [weak self] in
            guard let self = self else { return }
            self.subscriptionsPresenter.isLoading = false
            if case let .failure(error) = $0 {
                self.showRestoreError(error)
            } else {
                self.showSuccessView()
            }
        }
    }

    private func onPurchaseClickedOnRegistration(_ subscription: ProductSubscription) {
        self.subscriptionsPresenter.isLoading = true
        subscriptionsService.purchase(subscription) { [weak self] in
            guard let self = self else { return }
            self.subscriptionsPresenter.isLoading = false
            if case let .failure(error) = $0 {
                guard error != .canceled else { return }
                self.showPurchaseError(error)
            } else {
                self.showSuccessView()
            }
        }
    }

    private func showPurchaseError(_ error: PurchaseError) {
        var errorMessage = "Something went wrong;("
        if error.isOurSideError {
            errorMessage += " \("Please try to restore purchases or contact us.")"
        }
        let alertInfo = AlertInfo(title: "", message: errorMessage,
                                  buttons: [AlertInfo.Button(title: "Ok", action: {})])
        router.show(alert: alertInfo)
    }

    private func showRestoreError(_ error: PurchaseError) {
        let alertInfo = AlertInfo(title: "Sorry, no subscription found",
                                  message: "If you subscribed with a different Apple ID, sign in to this ID and try to restore. Or contact us to get help.",
                                  buttons: [AlertInfo.Button(title: "Ok", action: {})])
        router.show(alert: alertInfo)
    }

    private func showSuccessView() {
        let successView = SuccessScreen()
        router.present(view: successView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.router.dissmis()
            self.loginUser()
        }
    }
}
