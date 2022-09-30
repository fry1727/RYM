//
//  RYMWidgetView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 29.09.22.
//

import SwiftUI

struct RYMWidgetView: View {
    let remainders: [MedicineRemainder]
    
    var body: some View {
        VStack {
            Text("Todays remainders:")
            if todaysRemainders.isEmpty {
                Text("There are no reminders today")
            } else {
//                ForEach(todaysRemainders) { remainder in
//                    MedicineReminderWidgetView(medicineRemainder: remainder)
//                }
                                    if let remainder =  todaysRemainders.first {
                                        MedicineReminderWidgetView(medicineRemainder: remainder)
                                        Divider()
                                    }
                if todaysRemainders.count > 1 {
                    if let remainder = todaysRemainders[1] {
                        MedicineReminderWidgetView(medicineRemainder: remainder)
                        Divider()
                    }
                }
                if todaysRemainders.count > 2 {
                    if let remainder = todaysRemainders[2] {
                        MedicineReminderWidgetView(medicineRemainder: remainder)
                            .padding(.bottom, 5)
                    }
                }
            }

        }
        .padding(.top, 10)
        .padding(4)
    }

    var todaysRemainders: [MedicineRemainder] {
        let currentDay = Date().dayOfWeek() ?? ""
        return remainders.filter( { $0.weekDays?.contains(currentDay) ?? false })
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}

//struct RYMWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        RYMWidgetView(remainders: FetchedResults<MedicineRemainder>)
//    }
//}
