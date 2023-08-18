//
//  SubscriptionPresenter.swift
//  RYM
//
//  Created by Yauheni Skiruk on 17.08.23.
//

import Foundation

final class SubscriptionsPresenter: ObservableObject {
    static let shared = SubscriptionsPresenter()

    @Published var isLoading = false
    let subscriptionsService = SubscriptionService.shared
    let homeRouter = HomeRouter.shared
    let homePresenter = HomePresenter.shared

    func showPaywall() {
        let view = PaywallView(onCloseClicked: { self.homeRouter.dissmis() },
                               onRestoreClicked: onRestoreClicked,
                               onPurchaseClicked: { self.onPurchaseClicked($0) })
        homeRouter.present(view: view, transition: .coverVertical)
    }

    private func onRestoreClicked() {
        isLoading = true
        subscriptionsService.restorePurchases { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            if case let .failure(error) = $0 {
                print(error)
                self.showRestoreError(error)
            } else {
                AppConfig.shared.isVip = true
                self.showSuccessView()
            }
        }
    }

    private func onPurchaseClicked(_ subscription: ProductSubscription) {
        isLoading = true
        subscriptionsService.purchase(subscription) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            if case let .failure(error) = $0 {
                guard error != .canceled else { return }
                print(error)
                self.showPurchaseError(error)
            } else {
                AppConfig.shared.isVip = true
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
        homePresenter.show(alert: alertInfo)
    }

    private func showRestoreError(_ error: PurchaseError) {
        let alertInfo = AlertInfo(title: "Sorry, no subscription found",
                                  message: "If you subscribed with a different Apple ID, sign in to this ID and try to restore. Or contact us to get help.",
                                  buttons: [AlertInfo.Button(title: "Ok", action: {})])
        homePresenter.show(alert: alertInfo)
    }

    private func showSuccessView() {
        let successView = SuccessScreen()
        homeRouter.present(view: successView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.homeRouter.dissmis(animated: false) {
                self.homeRouter.dissmis()
            }
        }
    }
}
