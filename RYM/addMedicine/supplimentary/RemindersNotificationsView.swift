//
//  RemindersNotificationsView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 28.10.22.
//

import SwiftUI

struct RemindersNotificationsView: View {
    @EnvironmentObject var viewService: RemainderViewService
    let homeRouter = HomeRouter.shared
    let haptics = HapticsManager.shared
    @State var showNewReminder = false
    @State var newDate: Date = Date()

    var body: some View {
        VStack {
            remainders

            Button {
                viewService.reminderDates.append(newDate)
            } label: {
                Text("Add new time")
                    .foregroundColor(.orange)
                    .font(.callout)
            }
            .onAppear {
                if viewService.reminderDates.count < 1 {
                    viewService.reminderDates.append(Date())
                }
            }
            .padding(.vertical, 5)
            .opacity(viewService.isRemainderOn ? 1 : 0)
        }

    }

    private var remainders: some View {
        VStack {
            TextField("Reminder text", text: $viewService.remainderText)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .onChange(of: viewService.isRemainderOn, perform: { _ in
                    if viewService.isRemainderOn {
                        viewService.remainderText = viewService.title
                    }
                })
                .background(Color.gray.opacity(0.4),
                            in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                .opacity(viewService.isRemainderOn ? 1 : 0)

            TaggedView(availableWidth: UIScreen.main.bounds.width,
                       data: viewService.reminderDates.indices,
                       spacing: 4,
                       alignment: .leading) { indx in
                HStack(spacing: 12) {
                    Label {
                        Text(viewService.reminderDates[indx].formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.4),
                                in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        let view = TimePickerOverlay(newDate: $viewService.reminderDates[indx])
                        homeRouter.present(view: view)
                    }
                    .contextMenu{
                        Button(action: {
                            haptics.vibrateForSelection()
                            withAnimation(.easeOut(duration: 0.1)) {
                                viewService.reminderDates.remove(at: indx)
                            }
                        })
                        {
                            Text("Delete")
                        }
                    }
                }
                .frame(height: viewService.isRemainderOn ? nil : 0)
                .opacity(viewService.isRemainderOn ? 1 : 0)
                .opacity(viewService.notificationAccess ? 1 : 0)
            }
        }
    }
}

struct RemindersNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersNotificationsView(newDate: Date())
    }
}
