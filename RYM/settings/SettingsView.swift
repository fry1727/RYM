//
//  SettingsView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 15.09.22.
//

import SwiftUI
import CoreData

//MARK: - View for work with setting
struct SettingsView: View {
    @EnvironmentObject var viewService: RemainderViewService
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var appConfig = AppConfig.shared
    @ObservedObject var viewModel : SettingViewModel
    
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
                
                Section(header: Text("Sleep tracking settings")) {
                    Button {
                        viewModel.deleteButtonPressed(contex: viewContext)
                    } label: {
                        Text("Delete all data")
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingViewModel(viewService: RemainderViewService(), contex: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)))
    }
}
