//
//  AddNewRemainder.swift
//  RYM
//
//  Created by Yauheni Skiruk on 05/09/2022.
//

import SwiftUI
import CoreData

struct AddNewRemainder: View {
    @EnvironmentObject var viewModel: RemainderViewModel
    @Environment(\.self) var environment
    let weekDays = Calendar.current.weekdaySymbols

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

                remainder
            }
            .animation(.easeInOut, value: viewModel.isRemainderOn)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewModel.editRemainder == nil ? "Add Medicine Remainder" : "Edit Medicine Remainder")
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
        .overlay {
            if viewModel.showTimePicker {
                timePickerOverlay
            }
        }
    }

    private var titleTextField: some View {
        Group {
            TextField("Title", text: $viewModel.title)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.4),
                            in: RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
    }

    private var colorPicker: some View {
        HStack(spacing: 0) {
            ForEach(1...7, id: \.self) { index in
                let color = "Card-\(index)"
                Circle()
                    .fill(Color(color))
                    .frame(width: 30, height: 30)
                    .overlay(content: {
                        if color == viewModel.remainderColor {
                            Image(systemName: "checkmark")
                                .font(.caption.bold())
                        }
                    })
                    .onTapGesture {
                        withAnimation {
                            viewModel.remainderColor = color
                        }
                    }
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical)
    }

    private var frequencySelection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Frequency")
                .font(.callout.bold())

            HStack(spacing: 10) {
                ForEach(weekDays, id: \.self) { day in
                    let index = viewModel.weekDays.firstIndex { value in
                        return value == day
                    } ?? -1

                    Text(day.prefix(2))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(index != -1 ? Color(viewModel.remainderColor) : Color.gray.opacity(0.4))
                        }
                        .onTapGesture {
                            withAnimation {
                                if index != -1 {
                                    viewModel.weekDays.remove(at: index)
                                } else {
                                    viewModel.weekDays.append(day)
                                }
                            }
                        }
                }
            }
            .padding(.top, 10)
        }
    }

    private var remainderToggle: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Turn On remainder")
                    .fontWeight(.semibold)
                Text("App will send you a notification")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Toggle(isOn: $viewModel.isRemainderOn) {}
                .labelsHidden()
        }
    }

    private var timePickerOverlay: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        viewModel.showTimePicker.toggle()
                    }
                }
            DatePicker.init("", selection:
                                $viewModel.remainderDate, displayedComponents: [.hourAndMinute])
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
            }
            .padding()
        }
    }

    private var remainder: some View {
        HStack(spacing: 12) {
            Label {
                Text(viewModel.remainderDate.formatted(date: .omitted, time: .shortened))
            } icon: {
                Image(systemName: "clock")
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.4),
                        in: RoundedRectangle(cornerRadius: 6, style: .continuous))
            .onTapGesture {
                withAnimation {
                    viewModel.showTimePicker.toggle()
                }
            }

            TextField("Remainder text", text: $viewModel.remainderText)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.4),
                            in: RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
        .frame(height: viewModel.isRemainderOn ? nil : 0)
        .opacity(viewModel.isRemainderOn ? 1 : 0)
    }

    private var xmarkButton: some View {
        Group {
            Button {
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
                if viewModel.deleteRemainder(context: environment.managedObjectContext) {
                    environment.dismiss()
                }
            } label: {
                Image(systemName: "trash")
            }
            .tint(.red)
            .opacity(viewModel.editRemainder == nil ? 0 : 1)

        }
    }

    private var doneButton: some View {
        Group {
            Button("Done") {
                if viewModel.addRemainder(context: environment.managedObjectContext) {
                    environment.dismiss()
                }
            }
            .tint(.white)
            .disabled(!viewModel.doneStatus())
            .opacity(viewModel.doneStatus() ? 1 : 0.6)
        }
    }
}

struct AddNewRemainder_Previews: PreviewProvider {
    static var previews: some View {
        AddNewRemainder()
            .environmentObject(RemainderViewModel())
            .preferredColorScheme(.dark)
    }
}
