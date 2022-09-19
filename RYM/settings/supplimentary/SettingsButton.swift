//
//  SettingsButton.swift
//  RYM
//
//  Created by Yauheni Skiruk on 15.09.22.
//

import SwiftUI

struct SettingsButton: View {
    @State var buttonText: String
    @State var buttonAction: () -> Void

    var body: some View {
        Button {
            buttonAction()
        } label: {
            VStack {
                Text(buttonText)
                    .font(.callout)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .frame(width: 165, height: 165)
            .background(.orange)
            .cornerRadius(30)
        }

    }
}

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButton(buttonText: "Delete all remainders", buttonAction: {})
    }
}
