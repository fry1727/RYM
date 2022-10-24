//
//  OnboardingFeatureView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 08/09/2022.
//

import SwiftUI

// MARK: - Struct for features on onboarding screen
struct OnboardingFeatureView: View {
    var systemImageName: String
    var titleText: String
    var featureText: String

    var body: some View {
        HStack(spacing: 0) {

            Spacer()

            Image(systemName: systemImageName)
                .font(.system(size: 35))
                .foregroundColor(.orange)
            Spacer()

            VStack(alignment: .leading, spacing: 4) {
                Text(titleText)
                    .foregroundColor(.white)
                    .font(.subheadline.bold())
                Text(featureText)
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            .frame(alignment: .leading)
            .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

struct OnboardingFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Group {
                OnboardingFeatureView(systemImageName: "list.bullet.circle",
                                      titleText: "Watch your medicine",
                                      featureText: "You can easily manage your medicine. You can easily manage your medicine. You can easily manage your medicine")
                .padding(.bottom, 10)

                OnboardingFeatureView(systemImageName: "bell.circle",
                                      titleText: "Notification",
                                      featureText: "Flexibly set up notifications, never miss a dose of medication")
                .padding(.bottom, 10)
                OnboardingFeatureView(systemImageName: "lock.circle",
                                      titleText: "Privacy care",
                                      featureText: "We care about privacy and store all you data on your phone. Get easy access to manage and delete all data quickly")
            }
            .padding(.horizontal, 5)
        }
    }
}
