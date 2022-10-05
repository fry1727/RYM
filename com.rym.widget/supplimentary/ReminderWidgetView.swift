//
//  MedicineReminderWidgetView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 30.09.22.
//

import SwiftUI

struct ReminderWidgetView: View {
    
    @ObservedObject var medicineRemainder: MedicineRemainder
    
    var body: some View {
        VStack {
            HStack{
                Circle()
                    .frame(width: 5, height: 5)
                    .foregroundColor(.orange)
                Text(medicineRemainder.title ?? "")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(medicineRemainder.isRemainderOn ? "at \(medicineRemainder.notificationDate?.formatted(date: .omitted, time: .shortened) ?? "")" : "")
                    .font(.callout)
                    .foregroundColor(.white)
                Spacer()
            }
            
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 6)
    }
}

struct MedicineReminderWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderWidgetView(medicineRemainder: MedicineRemainder())
    }
}
