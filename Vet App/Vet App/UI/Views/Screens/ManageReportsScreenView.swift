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
    var petId : Int64
    
    //TODO: Doesnt auto refresh, have call to refresh on insert/update
    @StateObject var reportViewModel = ReportViewModel()
    
    var body : some View{
            VStack{
                Text("Manage Reports Screen")
                List(reportViewModel.reportsForPet, id: \.id){ item in
                    Button(action:{
                        print("Button Clicked!")
                    }){
                        Text(item.name)
                    }
                }
                if showDialog{
                    AddReportDialog(isPresented: $showDialog, reportName: $reportName, petId: petId, onSave: reportViewModel.insertReport)
                }
                Button("Add") {
                    showDialog = true
                }
            }.onAppear(){
                reportViewModel.GetReportsForPet(petId: petId)
            }
        }
        
        
}
