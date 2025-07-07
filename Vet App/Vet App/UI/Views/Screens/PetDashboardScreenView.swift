//
//  PetDashboard.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//

import SwiftUI

struct PetDashbaordScreenView : View{
    @StateObject var petvViewModel = PetViewModel()
    var petId : Int64
    var onNavigate: (AppRoute) -> Void
    @State private var selectedView : Int? = nil
    var body : some View{
              VStack{
                    Text("Pet Dashboard")
                    //TODO: Add graphs
                    Button("Manage Reports")
                    {
                        onNavigate(.manageReports(petId: petId))
                    }
                    .buttonStyle(AppButtonStyle())
                    Button("Reports"){
                        onNavigate(.reports(petId: petId))
                    }
                    .buttonStyle(AppButtonStyle())
                    Button("Reminders"){
                        onNavigate(.reminders)
                    }
                    .buttonStyle(AppButtonStyle())
                    Button("Pets"){
                        onNavigate(.pets(userId: 1))
                    }
                    .buttonStyle(AppButtonStyle())
                    
                    
                }
              .padding()
            }
        
}
