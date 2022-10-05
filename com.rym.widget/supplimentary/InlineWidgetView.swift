//
//  InlineWidgetView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 5.10.22.
//

import SwiftUI

struct InlineWidgetView: View {
    let remainders: [MedicineRemainder]

    var body: some View {
        Text("Today reminders: \(todaysRemainders.count)")
    }

    private  var todaysRemainders: [MedicineRemainder] {
        let currentDay = Date().dayOfWeek() ?? ""
        return remainders.filter( { $0.weekDays?.contains(currentDay) ?? false })
    }
}


