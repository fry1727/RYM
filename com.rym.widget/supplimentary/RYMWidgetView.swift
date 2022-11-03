//
//  RYMWidgetView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 29.09.22.
//

import SwiftUI
import WidgetKit

struct RYMWidgetView: View {
    @Environment(\.widgetFamily) var family
    let remainders: [MedicineRemainder]

    var body: some View {
        ZStack {
            Color.black
            VStack(alignment: .leading, spacing: 0) {
                widgetTitle
                    .padding(.horizontal, 10)
                Divider()
                Spacer()
                if todaysRemainders.isEmpty {
                    Text("There are no reminders today")
                } else {
                    if case .systemMedium = family {
                        mediumWidgetRemainderList
                        Spacer()
                    } else if case .systemLarge = family {
                        largeWidgetRemainderList
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding(.top, 10)
            .padding(5)
        }
    }

    private var mediumWidgetRemainderList: some View {
        Group {
            if let remainder =  todaysRemainders.first {
                ReminderWidgetView(medicineRemainder: remainder)
                Divider()
            }
            if todaysRemainders.count > 1 {
                if let remainder = todaysRemainders[1] {
                    ReminderWidgetView(medicineRemainder: remainder)
                    Divider()
                }
            }
            if todaysRemainders.count > 2 {
                if let remainder = todaysRemainders[2] {
                    ReminderWidgetView(medicineRemainder: remainder)
                    Text("see more in the app")
                        .frame(alignment: .center)
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                }
            }
        }
    }

    private var largeWidgetRemainderList: some View {
        Group {
            ForEach(todaysRemainders) { reminder in
                ReminderWidgetView(medicineRemainder: reminder)
                Divider()
            }
        }
    }

    private var widgetTitle: some View {
        HStack {
            Image(systemName: "pills")
                .font(.title2)
                .foregroundColor(.orange)
                .frame(width: 20, height: 20)
            Text("Today's reminders:    \(todaysRemainders.count)")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Spacer()
        }
    }

    private  var todaysRemainders: [MedicineRemainder] {
        let currentDay = Date().dayOfWeek() ?? ""
        return remainders.filter({ $0.weekDays?.contains(currentDay) ?? false })
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self).capitalized
    }
}
