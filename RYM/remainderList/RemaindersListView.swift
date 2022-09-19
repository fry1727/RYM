//
//  RemaindersListView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import CoreData

struct RemaindersListView: View {
    @FetchRequest(entity: MedicineRemainder.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \MedicineRemainder.dateAdded, ascending: false)],
                  predicate: nil, animation: .easeInOut) var remainders: FetchedResults<MedicineRemainder>
    @StateObject var viewModel = RemainderViewService()
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            Text("Remainders")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    plusButton
                }
                .overlay(alignment: .trailing) {
                    settingsButton
                }

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
            SettingsView()
                .environmentObject(viewModel)
//                .environment(\.managedObjectContext, viewContext)
        }
        .environment(\.managedObjectContext, viewContext)
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

    private var remaindersEmptyView: some View {
        VStack {
            Text("There is no medicine remainders")
                .foregroundColor(.white)
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .padding(.top, 100)
            Group {
                Text("Tap the icon ") +
                Text(Image(systemName: "plus.circle")) +
                Text(" to add new Medicine Reminder")
            }
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.top, 15)
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
        }
    }
}

struct RemaindersListView_Previews: PreviewProvider {
    static var previews: some View {
        RemaindersListView()
    }
}
