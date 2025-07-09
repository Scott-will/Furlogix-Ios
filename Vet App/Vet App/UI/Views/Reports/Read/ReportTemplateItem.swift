//
//  ReportTemplateItem.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-08.
//

import SwiftUI

struct ReportTemplateItem: View {
    @State private var showDialog = false
    @State private var showDeleteWarning = false

    var data: ReportTemplateField
    var onDeleteClick: (ReportTemplateField) -> Void
    var onUpdateClick: (ReportTemplateField) -> Void

    var body: some View {
        VStack {
            VStack(spacing: 8) {
                //IconDisplayer(iconName: data.icon)

                Text(data.name)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)

                HStack(spacing: 8) {
                    Button(action: {
                        showDialog = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.yellow)
                    }

                    Button(action: {
                        showDeleteWarning = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.3)) // Similar to ClickableItemRed
            )
            .frame(width: 140, height: 140)
        }
        .sheet(isPresented: $showDialog) {
            AddReportTemplateDialog(
                onSave: { updatedItem in
                    onUpdateClick(updatedItem)
                },
                currentLabel: data.name,
                selectedType: data.fieldType,
                currentUnit: "",//data.units,
                reportId: data.reportId,
                update: true,
                reportField: .constant(data)
            )
        }
        .alert("Delete Template", isPresented: $showDeleteWarning) {
            Button("Delete", role: .destructive) {
                onDeleteClick(data)
            }
            Button("Cancel", role: .cancel) {
                showDeleteWarning = false
            }
        } message: {
            Text("Deleting this report template will delete all associated data")
        }
    }
}
