//
//  ManageReportsView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//

import SwiftUI

struct ManageReportsScreenView : View{
    @State private var showDialog = false
    @State private var reportName = ""
    var onNavigate: (AppRoute) -> Void
    var petId : Int64
    
    //TODO: Doesnt auto refresh, have call to refresh on insert/update
    @StateObject var reportViewModel = ReportViewModel()
    
    var body : some View{
            VStack{
                Text("Manage Reports Screen")
                List(reportViewModel.reportsForPet, id: \.id){ item in
                    ReportItem(
                        data: item,
                        onClick: {
                            _ in onNavigate(AppRoute.reportEntryHistory(reportId: item.id))
                        },
                        onEditClick: {
                            _ in onNavigate(AppRoute.editReport(reportId: item.id))
                        },
                        onDeleteClick: {
                            _ in reportViewModel.deleteReport(id: item.id)
                            reportViewModel.GetReportsForPet(petId: petId)
                        },
                        onSendClick: {
                            _ in 
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let rootVC = scene.windows.first?.rootViewController {
                                reportViewModel.sendReport(id: item.id, presentingController: rootVC)
                                }
                        }
                    )
                }
                if showDialog{
                    AddReportDialog(isPresented: $showDialog, reportName: $reportName, petId: petId, onSave: reportViewModel.insertReport)
                }
                Button("Add") {
                    showDialog = true
                }.buttonStyle(AppButtonStyle())
            }.onAppear(){
                reportViewModel.GetReportsForPet(petId: petId)
            }
        }
        
        
}
