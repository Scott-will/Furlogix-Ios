//
//  ReportEntryHistoryView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//

import SwiftUI

struct ReportEntryHistoryScreenView : View{
    @State var reportId : Int64 = -1
    @StateObject var reportEntryViewModel = ReportEntryViewModel()
    
    var body : some View{
        VStack{
            Button(action:{
                
            }){
                Text("Add Data")
            }.buttonStyle(AppButtonStyle())
            Button(action:{
                
            }){
                Text("Send Report")
            }.buttonStyle(AppButtonStyle())
            Text("Report Entry History Screen")
        }.onAppear(){
            reportEntryViewModel.loadReportEntryList(reportId: reportId)
        }
    }
}
