//
//  ContinueButton.swift
//  RYM
//
//  Created by Yauheni Skiruk on 17.08.23.
//

import SwiftUI

struct ContinueButton: View {
    let action: () -> Void
    var isActive: Bool
    var text: String

    var body: some View {
        Button(action: action) {
            ZStack {
                HStack(alignment: .center, spacing: 16) {
                    Text(text)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .offset(x: 15)

                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    orangegradient
                )
                .cornerRadius(12)
            }
        }
        .frame(height: 56)
    }

    private var orangegradient: LinearGradient {
        LinearGradient(colors: [.orange, .yellow],
                       startPoint: .top, endPoint: .bottom)
    }
}

struct ContinueButton_Previews: PreviewProvider {
    static var previews: some View {
        ContinueButton(action: {}, isActive: true, text: "Start Free trial")
    }
}
