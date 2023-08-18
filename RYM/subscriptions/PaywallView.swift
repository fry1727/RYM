//
//  PaywallView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 17.08.23.
//

import SwiftUI
import Lottie

struct PaywallView: View {
    let onCloseClicked: () -> Void
    let onRestoreClicked: () -> Void
    let onPurchaseClicked: (ProductSubscription) -> Void

    @StateObject var subscriptionsService = SubscriptionService.shared
    @StateObject var subscriptionsPresenter = SubscriptionsPresenter.shared
    @State var selectedSubscriptionIndex: Int = 0

    let subText1 = "Unlimit medicine reminders, widget, easy access without Ads"
    let subText2 = "Try Free for 3 days, then 9,99 $/month. Cancel any time"

    init(onCloseClicked: @escaping () -> Void,
         onRestoreClicked: @escaping () -> Void,
         onPurchaseClicked: @escaping (ProductSubscription) -> Void
    ) {
        self.onCloseClicked = onCloseClicked
        self.onRestoreClicked = onRestoreClicked
        self.onPurchaseClicked = onPurchaseClicked
    }

    var body: some View {
        ZStack {
            gradientBackgrount
                .ignoresSafeArea()
            VStack {
                HStack(spacing: 0) {
                    Spacer()
                    noThanksButton
                }
                .padding(.horizontal, 10)
                .frame(height: 48)
                .frame(maxHeight: .infinity, alignment: .top)

                LottieView()
                    .frame(height: 300)
                    .padding(.bottom, 30)

                Text("Don't forget about your medications")
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .semibold))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.horizontal, 40)

                Text("Convenient & Easy")
                    .foregroundColor(.orange.opacity(0.7))
                    .font(.system(size: 30, weight: .heavy))

                Text(subText1)
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 50)
                    .padding(.top, 10)

                Text(subText2)
                    .foregroundColor(.black)
                    .font(.system(size: 11))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 15)

                Spacer()

                VStack(spacing: 8) {
                    ContinueButton(action: {
                        selectedSubscriptionIndex = 0
                        onContinueClicked()
                    }, isActive: true, text: "Start Free Trial")

                    restoreButton

                }
                .frame(alignment: .bottom)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
        }
        .progress(subscriptionsPresenter.isLoading) {
            subscriptionsPresenter.isLoading = false
        }
    }

    private func onContinueClicked() {
        let subscriptions = subscriptionsService.purchaseProducts
        guard var subscription = subscriptions.safeGet(selectedSubscriptionIndex) else { return }
        subscription.onPurchaseStarted = {
        }

        onPurchaseClicked(subscription)
    }

    private var noThanksButton: some View {
        return Button {
            onCloseClicked()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 22))
                .foregroundColor(Color.orange)
                .padding()
        }
    }

    private var restoreButton: some View {
        return  Button(action: {
            onRestoreClicked()
        }, label: {
            Text("Restore purchase")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        })
    }

    private var gradientBackgrount: LinearGradient {
        LinearGradient(colors: [.orange, .white.opacity(1)],
                       startPoint: .top, endPoint: .bottom)
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(onCloseClicked: {},
                    onRestoreClicked: {},
                    onPurchaseClicked: { _ in })
    }
}
