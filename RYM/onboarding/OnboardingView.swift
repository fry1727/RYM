//
//  OnboardingView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import CoreData

struct OnboardingView: View {
    var viewModel: OnboardingViewModel

    var body: some View {
        VStack {
            Image(systemName: "pills.circle")
                .font(.system(size: 90))
                .foregroundColor(.orange)
                .padding(.vertical, 40)

            tittleView

            Spacer()

            featuresView
                .padding(.horizontal, 5)

            Spacer()

            continueButton
                .padding(.bottom, 30)
        }
    }

    private var tittleView: some View {
        Group {
            Text("Welcome to")
                .font(.title.bold())
                .foregroundColor(.white)
            Text("Remind Your Medicine")
                .font(.title.bold())
                .foregroundColor(.orange)
        }
    }

    private var featuresView: some View {
        Group {
            OnboardingFeatureView(systemImageName: "list.bullet.circle",
                                  titleText: "Watch your medicine",
                                  featureText: "You can easily manage your medicine. Create, edite, remove your medicine reminders easely.")
            .padding(.bottom, 10)

            OnboardingFeatureView(systemImageName: "bell.circle",
                                  titleText: "Notification",
                                  featureText: "Flexibly set up notifications, never miss a dose of medication. Easely control your staff.")
            .padding(.bottom, 10)
            OnboardingFeatureView(systemImageName: "lock.circle",
                                  titleText: "Privacy care",
                                  featureText: "We care about privacy and store all you data on your phone. Get easy access to manage and delete all data quickly")
        }
    }

    private var continueButton: some View {
        Group {
            Button {
                viewModel.loginUser()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.orange)
                    Text("Continue")
                        .foregroundColor(.white)
                        .font(.callout)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .padding(.horizontal, 15)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModel(viewContext: NSPersistentContainer()))
    }
}
