//
//  ReportEntryView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//

import SwiftUI

struct ReportEntryScreenView : View{
    var reportId : Int64
    var onNavigate: (AppRoute) -> Void

    @StateObject var reportViewModel = ReportViewModel()
    @StateObject var reportTemplateViewModel = ReportTemplateViewModel()
    @StateObject var reportEntryViewModel = ReportEntryViewModel()
    
    @State var timestamp: String = ""
    @State private var templateValueMap: [Int64: String] = [:]

    
    var body : some View{
        VStack{
            Text("Report Entry Screen")
            List(reportTemplateViewModel.templatesForReports, id: \.id){ item in
                ReportEntryForm(reportName: self.reportViewModel.currentReport?.name ?? "",
                                fields: self.reportTemplateViewModel.templatesForReports,
                                templateValueMap: self.$templateValueMap,
                                timestamp: self.$timestamp)
            }
            Button(action: {
                reportEntryViewModel.insertReportEntry(entryValues: self.templateValueMap, reportId: self.reportId, timestamp: self.timestamp)
                //TODO: go back, not append to stack
                onNavigate(AppRoute.reportEntryHistory(reportId: self.reportId))
            }){
                Text("Save")
            }.buttonStyle(AppButtonStyle())
        }.onAppear(){
            reportTemplateViewModel.GetReportTemplateForReport(reportId: reportId)
            reportViewModel.loadCurrentReport(reportId: reportId)
        }
    }
}
