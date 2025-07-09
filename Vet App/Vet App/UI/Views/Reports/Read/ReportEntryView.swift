//
//  ReportEntry.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-09.
//

import SwiftUI

struct ReportEntryView: View {
    let reportTemplateField: ReportTemplateField
    @Binding var text: String

    @State private var isChecked: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(reportTemplateField.name)
                .font(.headline)

            switch reportTemplateField.fieldType {
            case .Number:
                TextField("Enter Number", text: Binding(
                    get: { text },
                    set: { newValue in
                        // Allow only valid numbers or empty string
                        if newValue.isEmpty || Double(newValue) != nil {
                            text = newValue
                        }
                    })
                )
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 8)

            case .Boolean:
                Toggle("Check if true", isOn: Binding(
                    get: {
                        Bool(text) ?? false
                    },
                    set: { newValue in
                        text = String(newValue)
                    }
                ))
                .padding(.horizontal, 8)

            case .Text:
                TextField("Enter Text", text: $text)
                    .keyboardType(.default)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 8)

            default:
                Text("Error in Template!!")
                    .foregroundColor(.red)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 4)
        )
        .padding(.vertical, 4)
    }
}
