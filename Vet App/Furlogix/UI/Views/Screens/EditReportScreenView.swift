//
//  EditReportScreen.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//
import SwiftUI

struct EditReportScreenView: View {
    let reportId: Int64
    @StateObject private var reportViewModel = ReportViewModel()
    @StateObject private var reportTemplatesViewModel = ReportTemplateViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDialog = false
    @State private var label = ""
    @State private var selectedType = FieldType.allCases.first
    @State private var newTemplateList: [ReportTemplateField] = []
    @State private var reportNameCopy: String? = nil
    @State private var isAnimated = false
    
    private var reportsTemplates: [ReportTemplateField] {
        reportTemplatesViewModel.templatesForReports + newTemplateList
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.97, green: 0.98, blue: 1.0),
                    Color(red: 0.93, green: 0.95, blue: 1.0),
                    Color(red: 0.88, green: 0.91, blue: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header Section
                    VStack(spacing: 4) {
                        Text("Edit Report")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                            .scaleEffect(isAnimated ? 1.0 : 0.8)
                            .animation(.easeOut(duration: 1.0), value: isAnimated)
                        
                        Text("Customize your report template")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
                    }
                    .padding(.top, 24)
                    
                    // Action Buttons Card
                    VStack(spacing: 0) {
                        HStack(spacing: 12) {
                            // Add Template Button
                            Button(action: { showDialog = true }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 18))
                                    Text("Add Field")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.4, green: 0.49, blue: 0.92))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                            }
                            
                            // Save Button
                            Button(action: saveReport) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 18))
                                    Text("Save")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.02, green: 0.59, blue: 0.41))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                            }
                        }
                        .padding(20)
                    }
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(radius: 8, y: 4)
                    
                    // Report Name Card
                    if reportViewModel.currentReport != nil {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 12) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                                
                                Text("Report Name")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                            }
                            
                                TextField("Enter Report Name", text: Binding(
                                    get: { reportNameCopy ?? "" },
                                    set: { reportNameCopy = $0 }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 16))
                                .padding(.vertical, 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(red: 0.4, green: 0.49, blue: 0.92), lineWidth: 1)
                                )
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(radius: 12, y: 4)
                    }
                    
                    // Report Fields Card
                    VStack(alignment: .leading, spacing: 16) {
                        if reportsTemplates.isEmpty {
                            // Empty state
                            VStack(spacing: 16) {
                                Image(systemName: "list.bullet")
                                    .font(.system(size: 64))
                                    .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.72))
                                
                                VStack(spacing: 4) {
                                    Text("No Fields Yet")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
                                    
                                    Text("Add fields to customize your report template")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.72))
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(.vertical, 40)
                        } else {
                            // Fields header
                            HStack {
                                HStack(spacing: 12) {
                                    Image(systemName: "list.bullet")
                                        .font(.system(size: 24))
                                        .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                                    
                                    Text("Report Fields")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                                }
                                
                                Spacer()
                                
                                Text("\(reportsTemplates.count) \(reportsTemplates.count == 1 ? "Field" : "Fields")")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.1))
                                    .cornerRadius(12)
                            }
                            
                            // Fields list
                            ReportTemplatesList(
                                templates: reportsTemplates,
                                onDeleteClick: { item in
                                    reportTemplatesViewModel.DeleteReportTemplate(templateId: item.id)
                                    reportTemplatesViewModel.GetReportTemplateForReport(reportId: reportId)
                                },
                                onUpdateClick: { item in
                                    reportTemplatesViewModel.UpdateReportTemplate(template: item)
                                    reportTemplatesViewModel.GetReportTemplateForReport(reportId: reportId)
                                }
                            )
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(radius: 12, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100) // Space for FAB
            }

        }
        .navigationBarHidden(true)
        .onAppear {
            setupInitialData()
            withAnimation {
                isAnimated = true
            }
            
        }
        .sheet(isPresented: $showDialog) {
            AddReportTemplateDialog(
                reportId: reportId,
                currentLabel: label,
                selectedType: selectedType ?? FieldType.Text,
                currentUnit: "",
                update: false,
                reportField: nil,
                onDismiss: { showDialog = false },
                onSave: { newItem in
                    newTemplateList.append(newItem)
                    label = ""
                    selectedType = FieldType.allCases.first
                    showDialog = false
                }
            )
        }
    }
    
    private func setupInitialData() {
        var report = reportViewModel.GetReportById(reportId: reportId)
        if(report == nil){
            return
        }
        reportViewModel.GetReportsForPet(petId: report?.petId ?? 0)
        reportViewModel.loadCurrentReport(reportId: reportId)
        reportNameCopy = reportViewModel.currentReport?.name ?? ""
        reportTemplatesViewModel.GetReportTemplateForReport(reportId: reportId)
    }
    
    private func saveReport() {
        // Save new template fields
        newTemplateList.forEach { item in
            reportTemplatesViewModel.InsertReportTemplate(template: item)
        }
        
        // Update existing template fields
        reportTemplatesViewModel.templatesForReports.forEach { item in
            reportTemplatesViewModel.UpdateReportTemplate(template: item)
        }
        
        if var report = reportViewModel.GetReportById(reportId: reportId) {
            report.name = reportNameCopy ?? report.name
            // Save back if needed
            reportViewModel.updateReport(report: report)
        }

        reportTemplatesViewModel.GetReportTemplateForReport(reportId: reportId)
        presentationMode.wrappedValue.dismiss()
    }
}
