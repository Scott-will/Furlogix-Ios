//
//  AddReportDialog.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//
import SwiftUI

struct AddReportDialogView: View {
    @Binding var currentLabel: String
    let onSave: (Report) -> Void
    let onDismiss: () -> Void
    @State private var reportName = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Report Name")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                    
                    TextField("Enter report name", text: $reportName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Add Report")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") { onDismiss() },
                trailing: Button("Save") {
                    let newItem = Report(id: 0, name: reportName, petId: 1)
                    onSave(newItem)
                }
                .disabled(reportName.isEmpty)
            )
        }
    }
}
