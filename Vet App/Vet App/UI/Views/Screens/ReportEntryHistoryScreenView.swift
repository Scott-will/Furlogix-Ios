//
//  ReportEntryHistoryView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//

import SwiftUI

struct ReportEntryHistoryScreenView : View{
    @State var reportId : Int64 = -1
    var onNavigate: (AppRoute) -> Void
    @StateObject var reportEntryViewModel = ReportEntryViewModel()
    @StateObject var reportViewModel = ReportViewModel()
    
    @State var showDialog = false
    var body : some View{
        VStack{
            Button(action:{
                onNavigate(AppRoute.reportEntry(reportId: reportId))
            }){
                Text("Add Data")
            }.buttonStyle(AppButtonStyle())
            Button(action:{
                
            }){
                Text("Send Report")
            }.buttonStyle(AppButtonStyle())
            Text("Report Entry History Screen")
            List {
                ForEach(reportEntryViewModel.groupedEntries.sorted(by: { $0.key < $1.key }), id: \.key) { item in
                    let timestamp = item.key
                    let entries = item.value

                    Section(header: Text("Timestamp: \(timestamp)")) {
                        ForEach(entries, id: \.id) { entry in
                            Text("Entry detail: \(entry.value)")
                        }
                    }
                }
            }
        }.onAppear(){
            reportEntryViewModel.loadReportEntryList(reportId: reportId)
        }
    }
}
