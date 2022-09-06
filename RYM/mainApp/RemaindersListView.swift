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
    @StateObject var viewmodel = RemainderViewModel()
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        VStack {
            Text("Remainders")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        viewmodel.addNewRemainder.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .overlay(alignment: .trailing) {
                    Button {

                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(remainders) { remainder in
                        MedicineReminderCard(medicineRemainder: remainder)
                    }
                }
            }

        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .sheet(isPresented: $viewmodel.addNewRemainder) {
            viewmodel.resetData()
        } content: {
            AddNewRemainder()
                .environmentObject(viewmodel)
                .environment(\.managedObjectContext, viewContext)
        }
        .environment(\.managedObjectContext, viewContext)
    }
}

struct RemaindersListView_Previews: PreviewProvider {
    static var previews: some View {
        RemaindersListView()
    }
}
