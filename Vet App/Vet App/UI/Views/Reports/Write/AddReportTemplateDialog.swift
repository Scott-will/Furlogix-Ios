//
//  AddReportTemplateDialog.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-08.
//

import SwiftUI

struct AddReportTemplateDialog: View {
    @Environment(\.dismiss) private var dismiss

    var onSave: (ReportTemplateField) -> Void

    var currentLabel: String
    var selectedType: FieldType
    var currentUnit: String
    var reportId: Int64
    var update: Bool = false
    var reportField: Binding<ReportTemplateField?> = .constant(nil)

    @State private var textFieldValue: String
    @State private var typeFieldValue: FieldType
    @State private var unitsFieldValue: String
    @State private var selectedIconName: String = "paw"

    init(
        onSave: @escaping (ReportTemplateField) -> Void,
        currentLabel: String,
        selectedType: FieldType,
        currentUnit: String,
        reportId: Int64,
        update: Bool = false,
        reportField: Binding<ReportTemplateField?> = .constant(nil)
    ) {
        self.onSave = onSave
        self.currentLabel = currentLabel
        self.selectedType = selectedType
        self.currentUnit = currentUnit
        self.reportId = reportId
        self.update = update
        self.reportField = reportField

        _textFieldValue = State(initialValue: currentLabel)
        _typeFieldValue = State(initialValue: selectedType)
        _unitsFieldValue = State(initialValue: currentUnit)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Field Name:")
            TextField("Enter Field Name", text: $textFieldValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Input Type:")
            Menu {
                ForEach(FieldType.allCases) { type in
                    Button(String(describing: type)) {
                        typeFieldValue = type
                    }
                }
            } label: {
                HStack {
                    Text(String(describing: typeFieldValue))
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            }

            Text("Field Units:")
            TextField("Enter Units if desired", text: $unitsFieldValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Select Icon:")
            //ReportTemplateIconSelector(selectedIconName: $selectedIconName)

            Spacer()

            Button("Save") {
                if update, var existingField = reportField.wrappedValue {
                    existingField.name = textFieldValue
                    //existingField.units = unitsFieldValue
                    existingField.fieldType = typeFieldValue
                    //existingField.icon = selectedIconName
                    onSave(existingField)
                } else {
                    let newField = ReportTemplateField(
                        reportId: reportId,
                        name: textFieldValue,
                        //units: unitsFieldValue,
                        //icon: selectedIconName,
                        fieldType: typeFieldValue
                    )
                    onSave(newField)
                }
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.accentColor))
            .foregroundColor(.white)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 8))
        .padding()
    }
}

