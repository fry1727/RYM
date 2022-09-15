//
//  SettingsView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 15.09.22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: RemainderViewModel
    @Environment(\.self) var environment

    var body: some View {
        NavigationView {

        VStack{
        HStack {
            SettingsButtonNofitication(buttonText: "Notification", buttonAction: {})
            SettingsButton(buttonText: "Erace all data", buttonAction: {})
        }
        .padding(.top, 50)
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                xmarkButton
            }
        }
    }

    }

    private var xmarkButton: some View {
        Group {
            Button {
//                environment.dismiss()
            } label: {
                Image(systemName: "xmark.circle")
            }
            .tint(.white)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
