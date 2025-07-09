//
//  AddReportDialog.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//
import SwiftUI

struct AddReportDialog : View{
    @Binding var isPresented : Bool
    @Binding var reportName : String
    var petId : Int64
    var onSave : (String, Int64) -> Int64?
    
    var body : some View{
        VStack(spacing: 20){
            CustomTextField(placeholder: "Report Name", text: $reportName)
            HStack{
                Button("Cancel") {
                    isPresented = false
                }
                .padding()
                
                Spacer()
                
                Button("Save") {
                    onSave(reportName, petId)
                    isPresented = false
                }
                .padding()
                .disabled(reportName.isEmpty)
            }
        }.padding()
            
    }
}
