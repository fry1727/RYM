//
//  SettingsButtonNofitication.swift
//  RYM
//
//  Created by Yauheni Skiruk on 15.09.22.
//

import SwiftUI

struct SettingsButtonNofitication: View {
    @State var buttonText: String
    @State var buttonAction: () -> Void
    @State var togleIsOn: Bool = AppConfig.shared.notificationAccess

    var body: some View {
        Toggle(isOn: $togleIsOn) {
            VStack {
                Text(buttonText)
                    .font(.callout)
                    .foregroundColor(.white)
            }


            .padding(.horizontal, 16)
            .cornerRadius(30)
            .frame(width: 150, height: 150)
        }
        .cornerRadius(30)
        .tint(.orange)
        .toggleStyle(.button)
        .overlay(RoundedRectangle(cornerRadius: 30)
            .strokeBorder(style: StrokeStyle(), antialiased: true)
            .foregroundColor(Color.orange)
        )
    }
}

struct SettingsButtonNofitication_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButtonNofitication(buttonText: "Delete all remainders", buttonAction: {})
    }
}
