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
    @FetchRequest(entity: MedicineRemainder.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \MedicineRemainder.dateAdded, ascending: false)],
                  predicate: nil, animation: .easeInOut) var remainders: FetchedResults<MedicineRemainder>
    @StateObject var viewModel = RemainderViewService()
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        if remainders.count == 0 {
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
            .sheet(isPresented: $viewModel.addNewRemainder) {
                viewModel.resetData()
            } content: {
                AddNewRemainder()
                    .environmentObject(viewModel)
                    .environment(\.managedObjectContext, viewContext)
            }
            .sheet(isPresented: $viewModel.settingPresented) {
            } content: {
                let settingsModel = SettingViewModel(viewService: viewModel, contex: viewContext)
                SettingsView(viewModel: settingsModel)
                    .environmentObject(viewModel)
            }
            .environment(\.managedObjectContext, viewContext)

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

    private var plusButton: some View {
        Group {
            Button {
                viewModel.addNewRemainder.toggle()
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
                viewModel.settingPresented.toggle()
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
                viewModel.addNewRemainder.toggle()
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
        ForEach(remainders) { remainder in
            MedicineReminderCard(medicineRemainder: remainder)
                .padding(.bottom, 10)
                .onTapGesture {
                    viewModel.editRemainder = remainder
                    viewModel.restoreEditingData()
                    viewModel.addNewRemainder.toggle()
                }
                .contextMenu {
                    Button(action: {
                        if let remainderContex = remainder.managedObjectContext {
                            viewModel.editRemainder = remainder
                            _ = viewModel.deleteRemainder(context: remainderContex)
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
        RemaindersListView()
    }
}
