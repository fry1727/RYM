//
//  SuccessScreen.swift
//  RYM
//
//  Created by Yauheni Skiruk on 17.08.23.
//

import Foundation
import SwiftUI

struct SuccessScreen: View {
    var body: some View {
        ZStack {
            gradientBackgrount
                .ignoresSafeArea()
            VStack {
                LottieView()
                    .frame(height: 300)
                    .padding(.bottom, 30)
                Text("Congratulations!")
                    .foregroundColor(.red)
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.bottom, 16)
                Group {
                    Text("You have a")
                        .foregroundColor(.black)
                    +
                    Text(" PRO version ")
                        .foregroundColor(.orange.opacity(0.7))
                    +
                    Text("now")
                        .foregroundColor(.black)
                }
                .font(.system(size: 20, weight: .semibold))

            }
        }
        .onAppear {
            AppConfig.shared.isVip = true
        }
    }

    private var gradientBackgrount: LinearGradient {
        LinearGradient(colors: [.orange, .white.opacity(1)],
                       startPoint: .top, endPoint: .bottom)
    }
}

struct SuccessScreen_Previews: PreviewProvider {
    static var previews: some View {
        SuccessScreen()
    }
}
