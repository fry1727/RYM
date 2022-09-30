//
//  RemaindersListView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import CoreData

//MARK: - Main view of the application
struct RemaindersListView: View {
    @ObservedObject var viewService: RemainderViewService
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    
    let haptics = HapticsManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        if viewService.remainders.count == 0 {
                            remaindersEmptyView
                        } else {
                            reminderCardList
                        }
                    }
                    .padding(.bottom, 60)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .sheet(isPresented: $viewService.addNewRemainder) {
                viewService.resetData()
            } content: {
                AddNewRemainder()
                    .environmentObject(viewService)
                    .environment(\.managedObjectContext, viewContext)
            }
            .sheet(isPresented: $viewService.settingPresented) {
            } content: {
                let settingsModel = SettingViewModel(viewService: viewService)
                SettingsView(viewModel: settingsModel)
                    .environmentObject(viewService)
            }
            .searchable(text: $searchText)
            .navigationBarTitle(Text("Remainders"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    plusButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    settingsButton
                }
            }
            .overlay(bigPlusButton, alignment: .bottom)
        }
    }
    
    private var searchResults: [MedicineRemainder] {
        if searchText.isEmpty {
            return viewService.remainders.sorted(by: { $0.dateAdded?.timeIntervalSince1970 ?? 0 > $1.dateAdded?.timeIntervalSince1970 ?? 0 })
        } else {
            return viewService.remainders.filter { $0.title?.contains(searchText) ?? false }
        }
    }
    
    private var plusButton: some View {
        Group {
            Button {
                haptics.vibrateForSelection()
                viewService.addNewRemainder.toggle()
            } label: {
                Image(systemName: "plus.circle")
                    .font(.title3)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var settingsButton: some View {
        Group {
            Button {
                haptics.vibrateForSelection()
                viewService.settingPresented.toggle()
            } label: {
                Image(systemName: "gearshape")
                    .font(.title3)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var bigPlusButton: some View {
        HStack {
            Spacer()
            Button {
                haptics.vibrateForSelection()
                viewService.addNewRemainder.toggle()
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .background(
                        Circle()
                            .foregroundColor(.orange)
                            .frame(width: 70, height: 70))
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 130)
        }
    }
    
    private var remaindersEmptyView: some View {
        VStack {
            Text("There is no medicine remainders")
                .foregroundColor(.white)
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .padding(.top, 200)
            Group {
                Text("Tap the icon ") +
                Text(Image(systemName: "plus.circle")) +
                Text(" to add new reminder")
            }
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.top, 15)
            Text("or tap on + button below")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
    
    private var reminderCardList: some View {
        ForEach(Array(zip(searchResults.indices, searchResults)), id: \.0) { index, remainder in
            MedicineReminderCard(medicineRemainder: remainder)
                .padding(.bottom, 10)
                .id(remainder.id)
                .onTapGesture {
                    haptics.vibrateForSelection()
                    viewService.editRemainder = remainder
                    viewService.restoreEditingData()
                    viewService.addNewRemainder.toggle()
                }
                .contextMenu {
                    Button(action: {
                        haptics.vibrateForSelection()
                        withAnimation(.easeOut(duration: 0.1)) {
                            viewService.editRemainder = remainder
                            _ = viewService.deleteRemainder()
                        }
                    } ) {
                        Text("Delete")
                    }
                }
        }
    }
}

struct RemaindersListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        RemaindersListView(viewService: RemainderViewService(context: context))
    }
}
