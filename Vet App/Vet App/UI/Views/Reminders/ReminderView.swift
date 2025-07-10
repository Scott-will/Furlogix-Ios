//
//  ReminderView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-09.
//

import SwiftUI

struct ReminderItem: View {
    let data: Reminder
    let onDeleteClick: (Reminder) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.8))

            HStack(alignment: .center) {
                Text(data.startTime)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(data.frequency)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 8)

                Button(action: {
                    onDeleteClick(data)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                }
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
    }
}
