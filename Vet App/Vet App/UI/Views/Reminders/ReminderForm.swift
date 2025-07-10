//
//  ReminderForm.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-09.
//

import SwiftUI

struct ReportsReminder: View {
    @Environment(\.dismiss) var dismiss // Use if using .sheet

    @ObservedObject var remindersViewModel: ReminderViewModel = ReminderViewModel()

    @State private var selectedDateTime: Date = Date()
    @State private var recurrenceOption: String = "Once"
    @State private var reminderTitle: String = ""
    @State private var reminderText: String = ""
    @State private var recurrenceExpanded: Bool = false

    private let recurrenceOptions = ["Once", "Daily", "Weekly", "Monthly"]

    var body: some View {
        VStack(spacing: 16) {
            Text("Schedule a Reminder")
                .font(.title2)
                .bold()

            TextField("Title", text: $reminderTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Message", text: $reminderText)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            VStack(alignment: .leading) {
                Text("Frequency")
                    .font(.subheadline)

                Menu {
                    ForEach(recurrenceOptions, id: \.self) { option in
                        Button(option) {
                            recurrenceOption = option
                        }
                    }
                } label: {
                    HStack {
                        Text(recurrenceOption)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                }
            }

            DatePicker("Select Date & Time", selection: $selectedDateTime, displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .datePickerStyle(GraphicalDatePickerStyle())

            Button(action: {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                let startTimeString = formatter.string(from: selectedDateTime)
                let reminder = Reminder(id : -1, frequency: recurrenceOption, startTime: startTimeString, title: reminderTitle, message: reminderText, requestId: UUID().uuidString)
                remindersViewModel.insertReminder(reminder: reminder)
                dismiss() 
            }) {
                Text("Schedule Reminder")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: 400)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 10)
        )
        .padding()
    }
}
