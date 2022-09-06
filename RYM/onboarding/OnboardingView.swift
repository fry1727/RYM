//
//  OnboardingView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        ZStack {
            Color.green
                .opacity(0.7)
                .ignoresSafeArea()
            Text("Onboarding screen")
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
