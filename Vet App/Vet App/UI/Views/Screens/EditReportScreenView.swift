//
//  EditReportScreen.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

import SwiftUI

struct EditReportScreenView : View{
    @State var reportId : Int64
    @State var showDialog = false
    @State private var label = ""
    @State private var selectedType: FieldType = FieldType.allCases.first ?? .Text
    @State private var newTemplateList: [ReportTemplateField] = []
    
    @StateObject var reportViewModel = ReportViewModel()
    @StateObject var reportTemplateViewModel = ReportTemplateViewModel()
    
    var body : some View{
        VStack{
            Button(action: {
                showDialog = true
            }){
                Text("Add Report Template")
            }.buttonStyle(AppButtonStyle())
            Button(action: {
                for item in self.newTemplateList{
                    reportTemplateViewModel.InsertReportTemplate(template: item)
                }
            }){
                Text("Save")
            }.buttonStyle(AppButtonStyle())
            Text("Edit Report Screen")
            List(reportTemplateViewModel.templatesForReports, id: \.id){ item in
                ReportTemplateItem(data: item,
                                   onDeleteClick: {
                    _ in reportTemplateViewModel.DeleteReportTemplate(templateId: item.id)
                },
                                   onUpdateClick:{
                    _ in reportTemplateViewModel.UpdateReportTemplate(template:item)
                }
                )}
            }.onAppear(){
                reportTemplateViewModel.GetReportTemplateForReport(reportId: reportId)
            }
            .sheet(isPresented: $showDialog) {
                AddReportTemplateDialog(
                    onSave: { newItem in
                        newTemplateList.append(newItem)
                        label = ""
                        selectedType = FieldType.allCases.first ?? .Text
                    },
                    currentLabel: label,
                    selectedType: selectedType,
                    currentUnit: "",
                    reportId: reportId
                )
            }
            
    }
}
