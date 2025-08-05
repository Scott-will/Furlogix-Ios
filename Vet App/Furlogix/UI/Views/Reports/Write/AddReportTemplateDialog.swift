//
//  AddReportTemplateDialog.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-08.
//
import SwiftUI

import SwiftUI

struct AddReportTemplateDialog: View {
    let reportId: Int64
    let currentLabel: String
    let selectedType: FieldType
    let currentUnit: String
    let update: Bool
    let reportField: ReportTemplateField?
    let onDismiss: () -> Void
    let onSave: (ReportTemplateField) -> Void

    @State private var textFieldValue: String
    @State private var typeFieldValue: String
    @State private var unitsFieldValue: String
    @State private var selectedIconName = "pawprint.fill"
    @State private var isDropdownExpanded = false

    private let fieldTypes = FieldType.allCases

    init(reportId: Int64,
         currentLabel: String,
         selectedType: FieldType,
         currentUnit: String,
         update: Bool = false,
         reportField: ReportTemplateField? = nil,
         onDismiss: @escaping () -> Void,
         onSave: @escaping (ReportTemplateField) -> Void) {
        self.reportId = reportId
        self.currentLabel = currentLabel
        self.selectedType = selectedType
        self.currentUnit = currentUnit
        self.update = update
        self.reportField = reportField
        self.onDismiss = onDismiss
        self.onSave = onSave

        _textFieldValue = State(initialValue: currentLabel)
        _typeFieldValue = State(initialValue: selectedType.displayName)
        _unitsFieldValue = State(initialValue: currentUnit)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        FieldNameSection(textFieldValue: $textFieldValue)
                        InputTypeSection(
                            typeFieldValue: $typeFieldValue,
                            isDropdownExpanded: $isDropdownExpanded,
                            fieldTypes: fieldTypes
                        )
                        FieldUnitsSection(unitsFieldValue: $unitsFieldValue)

                        // Icon selector section (optional)
                        /*
                        ReportTemplateIconSelector(
                            selectedIconName: selectedIconName,
                            onIconSelected: { selectedIconName = $0 }
                        )
                        */
                    }
                    .padding(.horizontal, 20)
                }

                SaveButton(isDisabled: textFieldValue.isEmpty) {
                    handleSave()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle(update ? "Edit Field" : "Add Field")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel", action: onDismiss))
        }
    }

    private func handleSave() {
        let selectedType = fieldTypes.first(where: { $0.displayName == typeFieldValue }) ?? .Text
        let field = ReportTemplateField(
            reportId: reportId,
            name: textFieldValue,
            fieldType: selectedType,
            //unit: unitsFieldValue,
            //iconName: selectedIconName
        )
        onSave(field)
    }
}

struct FieldNameSection: View {
    @Binding var textFieldValue: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Field Name:")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
            TextField("Enter Field Name", text: $textFieldValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 16))
        }
    }
}

struct InputTypeSection: View {
    @Binding var typeFieldValue: String
    @Binding var isDropdownExpanded: Bool
    let fieldTypes: [FieldType]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Input Type:")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))

            VStack(spacing: 0) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isDropdownExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text(typeFieldValue.isEmpty ? "Select Input Type" : typeFieldValue)
                            .foregroundColor(typeFieldValue.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: isDropdownExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(8)
                }

                if isDropdownExpanded {
                    VStack(spacing: 0) {
                        ForEach(fieldTypes, id: \.self) { type in
                            Button(action: {
                                typeFieldValue = type.displayName
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isDropdownExpanded = false
                                }
                            }) {
                                HStack {
                                    Text(type.displayName)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())

                            if type != fieldTypes.last {
                                Divider().padding(.horizontal, 12)
                            }
                        }
                    }
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(8)
                    .shadow(radius: 4, y: 2)
                }
            }
        }
    }
}

struct FieldUnitsSection: View {
    @Binding var unitsFieldValue: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Field Units:")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
            TextField("Enter Units if desired", text: $unitsFieldValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 16))
        }
    }
}

struct SaveButton: View {
    let isDisabled: Bool
    let onSave: () -> Void

    var body: some View {
        Button(action: onSave) {
            Text("Save")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(red: 0.4, green: 0.49, blue: 0.92))
                .cornerRadius(12)
        }
        .disabled(isDisabled)
    }
}
