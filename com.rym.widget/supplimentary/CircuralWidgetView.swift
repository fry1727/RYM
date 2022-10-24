//
//  CircuralWidgetView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 5.10.22.
//

import SwiftUI

struct CircuralWidgetView: View {
    let remainders: [MedicineRemainder]

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "pills")
                .foregroundColor(.orange)
                .font(.headline)
            Text("\(todaysRemainders.count)")
                .font(.headline)
                .fontWeight(.semibold)
        }
        .background {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(Color.gray.opacity(0.6))
        }
    }

    private  var todaysRemainders: [MedicineRemainder] {
        let currentDay = Date().dayOfWeek() ?? ""
        return remainders.filter({ $0.weekDays?.contains(currentDay) ?? false })
    }
}
