//
//  TimePickerOverlay.swift
//  RYM
//
//  Created by Yauheni Skiruk on 31.10.22.
//

import SwiftUI

struct TimePickerOverlay: View {
    var homeRouter = HomeRouter.shared
    @State var newDate: Binding<Date>

    var body: some View {
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            UIApplication.shared.endEditing()
                        }
                    }
                VStack {
                    DatePicker.init("", selection:
                                        newDate, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding([.top, .horizontal])

                    Text("* tap to close")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding()
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                }
                .padding()
            }
            .onTapGesture {
                homeRouter.dissmis()
            }
        }
}

struct TimePickerOverlay_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerOverlay(newDate: .constant(Date()))
    }
}
