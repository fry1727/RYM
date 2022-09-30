//
//  MedicineReminderWidgetView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 30.09.22.
//

import SwiftUI

struct MedicineReminderWidgetView: View {

    @ObservedObject var medicineRemainder: MedicineRemainder

    var body: some View {
        VStack {
            HStack{
                Text(medicineRemainder.title ?? "")
                Text("\(medicineRemainder.weekDays?.count ?? 0) times a week")
                Spacer()
            }

        }
        .padding(.vertical, 6)
        .padding(.horizontal, 6)
    }


    
///Convert date to string
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"

        return formatter.string(from: date)
    }
}

struct MedicineReminderWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MedicineReminderWidgetView(medicineRemainder: MedicineRemainder())
    }
}
