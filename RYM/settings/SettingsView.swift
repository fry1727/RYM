//
//  SettingsView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 15.09.22.
//

import SwiftUI
import CoreData

// MARK: - View for work with setting
struct SettingsView: View {
    @EnvironmentObject var viewService: RemainderViewService
    @StateObject var appConfig = AppConfig.shared
    @ObservedObject var viewModel: SettingViewModel
    private let homeRouter = HomeRouter.shared

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notifications settings")) {
                    Toggle(isOn: $appConfig.notificationsTurnOn) {
                        Text("Notification:")
                    }
                    .onChange(of: appConfig.notificationsTurnOn) { newValue in
                        if newValue {
                            if appConfig.notificationAccess == false {
                                Notifications.shared.permissionGranted { granted in
                                    if granted {
                                        viewModel.turnOnNotifications()
                                    } else {
                                        DispatchQueue.main.async {
                                            appConfig.notificationsTurnOn = false
                                            viewModel.goToSettingAlertPresent()
                                        }
                                    }
                                }
                            } else {
                                viewModel.turnOnNotifications()
                            }
                        } else {
                            DispatchQueue.main.async {
                                viewModel.turnOffNotificationAlertPresent()
                            }
                        }
                    }
                }

                Section(header: Text("Deleting all data")) {
                    Button {
                        viewModel.deleteButtonPressed()
                    } label: {
                        Text("Delete all data")
                            .foregroundColor(Color.white)
                    }
                }

                Section(header: Text("Privacy and Complience")) {
                    Button {
                        goToTermsOfUse()
                    } label: {
                        Text("Terms of use")
                            .foregroundColor(Color.white)
                    }

                    Button {
                        goToPrivacy()
                    } label: {
                        Text("Privacy policy")
                            .foregroundColor(Color.white)
                    }
                }

                Section(header: Text("Saharing")) {
                    Button {
                        shareAppSheet()
                    } label: {
                        Text("Share app")
                            .foregroundColor(Color.white)
                    }
                }
            }
            .onAppear {
                if !appConfig.notificationAccess {
                    appConfig.notificationsTurnOn = false
                }
            }
            .navigationBarTitle(Text("Settings"))
            .navigationBarTitleDisplayMode(.inline)
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
                viewService.settingPresented.toggle()
            } label: {
                Image(systemName: "xmark.circle")
            }
            .tint(.white)
        }
    }

    private func goToTermsOfUse() {
        guard let urlShare = URL(string: "https://telegra.ph/Terms--Conditions-10-22-2") else { return }
        let view = WebViewSettingsPage(url: urlShare, header: "Terms of use")
        homeRouter.present(view: view)
    }

    private func goToPrivacy() {
        guard let urlShare = URL(string: "https://telegra.ph/Privacy-Policy-10-22-17") else { return }
        let view = WebViewSettingsPage(url: urlShare, header: "Privacy Policy")
        homeRouter.present(view: view)
    }

    private func shareAppSheet() {
        guard let urlShare = URL(string: "https://apps.apple.com/us/app/id1632314541") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        SettingsView(viewModel: SettingViewModel(viewService: RemainderViewService(context: context)))
    }
}
