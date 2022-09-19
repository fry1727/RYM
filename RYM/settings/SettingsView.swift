//
//  SettingsView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 15.09.22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: RemainderViewService
    //    @Environment(\.self) var environment

    var body: some View {
        NavigationView {

            VStack{
                HStack {
                    SettingsButtonNofitication(buttonText: "Notification", buttonAction: {})
                    SettingsButton(buttonText: "Erace all data", buttonAction: {
                        deletionalert()
                    })
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
                viewModel.settingPresented.toggle()
            } label: {
                Image(systemName: "xmark.circle")
            }
            .tint(.white)
        }
    }

    private func deletionalert() {
        let alertBtnYes = AlertInfo.Button(title: "Yes", style: .destructive, action: {
            viewModel.deleteAllData()
        })
        let alertBtnNo = AlertInfo.Button(title: "No", action: {})
        let alert = AlertInfo(title: "Delete all remainders?",
                              message: "By tapping YES you will remove all your data",
                              buttons: [ alertBtnYes, alertBtnNo ])
        HomePresenter.shared.show(alert: alert)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
