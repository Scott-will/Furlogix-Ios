//
//  ReportEntryForm.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-09.
//

import SwiftUI

struct ReportEntryForm: View {
  let reportName: String
  let fields: [ReportTemplateField]
  @Binding var templateValueMap: [Int64: String]
  @Binding var timestamp: String

  @State private var selectedDate: Date = Date()
  private let dateFormatter = DateFormatter()

  init(
    reportName: String,
    fields: [ReportTemplateField],
    templateValueMap: Binding<[Int64: String]>,
    timestamp: Binding<String>
  ) {
    self.reportName = reportName
    self.fields = fields
    self._templateValueMap = templateValueMap
    self._timestamp = timestamp

    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(reportName)
        .font(.headline)

      if fields.isEmpty {
        /*NoDataAvailable(text: "Templates")
            .frame(maxWidth: .infinity, maxHeight: .infinity)*/
      } else {
        ForEach(fields, id: \.id) { field in
          ReportEntryView(
            reportTemplateField: field,
            text: Binding(
              get: { templateValueMap[field.id, default: ""] },
              set: { templateValueMap[field.id] = $0 }
            )
          )
        }

        DatePicker(
          "Select date and time", selection: $selectedDate,
          displayedComponents: [.date, .hourAndMinute]
        )
        .onChange(of: selectedDate) { newDate in
          timestamp = dateFormatter.string(from: newDate)
        }

        Text("Selected: \(timestamp.isEmpty ? "No date selected" : timestamp)")
          .padding(.top, 8)
      }

      Spacer()
    }
    .padding(16)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color(.systemBackground))
        .shadow(radius: 4)
    )
    .padding(.horizontal)
  }
}
