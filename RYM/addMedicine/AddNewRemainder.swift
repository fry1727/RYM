//
//  AddNewRemainder.swift
//  RYM
//
//  Created by Yauheni Skiruk on 05/09/2022.
//

import SwiftUI
import CoreData

// MARK: - Struct for adding new reminder
struct AddNewRemainder: View {
    @EnvironmentObject var viewService: RemainderViewService
    @Environment(\.self) var environment

    let weekDays: [String] = Array(Calendar.current.shortWeekdaySymbols[Calendar.current.firstWeekday - 1 ..< Calendar.current.shortWeekdaySymbols.count]
                                   + Calendar.current.shortWeekdaySymbols[0 ..< Calendar.current.firstWeekday - 1])

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {

                titleTextField

                colorPicker

                Divider()

                frequencySelection

                Divider()
                    .padding(.vertical, 10)

                remainderToggle

                RemindersNotificationsView()
                    .environmentObject(viewService)
            }
            .animation(.easeInOut, value: viewService.isRemainderOn)
            .padding(.vertical)
            .padding(.horizontal, 6)
            .frame(maxHeight: .infinity, alignment: .top)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewService.editRemainder == nil ? "Add Medicine Reminder" : "Edit Medicine Reminder")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    xmarkButton
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    deleteButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    doneButton
                }
            }
        }
    }

    private var titleTextField: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Reminder title:")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            TextField("Reminder title", text: $viewService.title)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.4),
                            in: RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }

    private var colorPicker: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Color:")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            HStack(spacing: 0) {
                ForEach(1...7, id: \.self) { index in
                    let color = "Card-\(index)"
                    Circle()
                        .fill(Color(color))
                        .frame(width: 30, height: 30)
                        .overlay(content: {
                            if color == viewService.remainderColor {
                                Image(systemName: "checkmark")
                                    .font(.caption.bold())
                            }
                        })
                        .onTapGesture {
                            withAnimation {
                                viewService.remainderColor = color
                            }
                        }
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)
            .padding(.top, 5)
        }
    }

    private var frequencySelection: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("Frequency: ")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Text("Everyday")
                    .font(.caption)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(viewService.weekDays.count == 7 ? Color(viewService.remainderColor) :
                                    Color.gray.opacity(0.4))
                    }
                    .onTapGesture {
                        viewService.weekDays.removeAll()
                        for weekday in weekDays {
                            viewService.weekDays.append(weekday)
                        }
                    }
            }
            HStack(spacing: 10) {
                ForEach(weekDays, id: \.self) { day in
                    let index = viewService.weekDays.firstIndex { value in
                        return value == day
                    } ?? -1

                    Text(day.prefix(2))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(index != -1 ? Color(viewService.remainderColor) : Color.gray.opacity(0.4))
                        }
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            withAnimation {
                                if index != -1 {
                                    viewService.weekDays.remove(at: index)
                                } else {
                                    viewService.weekDays.append(day)
                                }
                            }
                        }
                }
            }
            .padding(.top, 10)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }

    private var remainderToggle: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Turn On notifications")
                    .fontWeight(.semibold)
                Text("App will send you a notifications")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            Toggle(isOn: $viewService.isRemainderOn) {}
                .labelsHidden()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
        }
        .opacity(viewService.notificationAccess ? 1 : 0)
    }

    private var xmarkButton: some View {
        Group {
            Button {
                UIApplication.shared.endEditing()
                environment.dismiss()
            } label: {
                Image(systemName: "xmark.circle")
            }
            .tint(.white)
        }
    }

    private var deleteButton: some View {
        Group {
            Button {
                if viewService.deleteRemainder() {
                    UIApplication.shared.endEditing()
                    environment.dismiss()
                }
            } label: {
                Image(systemName: "trash")
            }
            .tint(.red)
            .opacity(viewService.editRemainder == nil ? 0 : 1)

        }
    }

    private var doneButton: some View {
        Group {
            Button("Done") {
                if viewService.addRemainder() {
                    UIApplication.shared.endEditing()
                    environment.dismiss()
                }
            }
            .tint(.white)
            .disabled(!viewService.doneStatus())
            .opacity(viewService.doneStatus() ? 1 : 0.6)
        }
    }

    private var saveButton: some View {
        Group {
            Button("Save") {
                if viewService.addRemainder() {
                    UIApplication.shared.endEditing()
                    environment.dismiss()
                }
            }
            .tint(.white)
        }
    }
}

struct AddNewRemainder_Previews: PreviewProvider {
    static var previews: some View {
        AddNewRemainder()
            .preferredColorScheme(.dark)
    }
}
