//
//  MedicineReminderCard.swift
//  RYM
//
//  Created by Yauheni Skiruk on 05/09/2022.
//

import SwiftUI

//MARK: - Card for showing remainder in remainders list
struct MedicineReminderCard: View {
    var medicineRemainder: MedicineRemainder

    var body: some View {
        VStack(spacing: 6) {

            remainderTitle
                .padding(.horizontal, 10)

            calendarView
                .padding(.top, 15)

        }
        .padding(.vertical)
        .padding(.horizontal, 6)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.5))
        }
    }

    private var remainderTitle: some View {
        HStack {
            Text(medicineRemainder.title ?? "")
                .font(.callout)
                .fontWeight(.semibold)
                .lineLimit(1)

            Image(systemName: "bell.badge.fill")
                .font(.callout)
                .foregroundColor(Color(medicineRemainder.color ?? "Card-1"))
                .scaleEffect(0.9)
                .opacity(medicineRemainder.isRemainderOn ? 1 : 0)

            Spacer()

            let count = (medicineRemainder.weekDays?.count ?? 0)
            Text(count == 7 ? "Everyday" : "\(count) times a week")
                .font(.callout)
                .foregroundColor(.gray)
        }
    }

    private var calendarView: some View {
        Group {
            let calendar = Calendar.current
            let currentWeek = calendar.dateInterval(of: .weekOfMonth, for: Date())
            let symbols = calendar.weekdaySymbols
            let startDay = currentWeek?.start ?? Date()
            let activeWeekDays = medicineRemainder.weekDays ?? []
            let activeDay = symbols.indices.compactMap { index -> (String, Date) in
                let currentDay = calendar.date(byAdding: .day, value: index, to: startDay)
                guard let currentDay = currentDay else {
                    return (symbols[index], Date())
                }
                return (symbols[index], currentDay)
            }

            HStack(spacing: 0) {
                ForEach(activeDay.indices, id: \.self) { index in
                    let item = activeDay[index]

                    VStack(spacing: 6) {
                        Text(item.0.prefix(3))
                            .font(.callout)
                            .foregroundColor(.gray)

                        let status = activeWeekDays.contains { day in
                            return day == item.0
                        }

                        Text(dateToString(date: item.1))
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .padding(8)
                            .background {
                                Circle()
                                    .fill(Color(medicineRemainder.color ?? "Card-1"))
                                    .opacity(status ? 1: 0)
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
///Convert date to string
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"

        return formatter.string(from: date)
    }
}

struct MedicineReminderCard_Previews: PreviewProvider {
    static var previews: some View {
        let remainder = MedicineRemainder()
        MedicineReminderCard(medicineRemainder: remainder)
    }
}
