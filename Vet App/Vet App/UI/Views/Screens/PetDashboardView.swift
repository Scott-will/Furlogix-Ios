//
//  PetDashboard.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//

import SwiftUI

struct PetDashbaordView : View{
    @StateObject var petvViewModel = PetViewModel()
    var petId : Int64
    @State private var selectedView : Int? = nil
    var body : some View{
              VStack{
                    Text("Pet Dashboard")
                    //TODO: Add graphs
                    Button("Manage Reports"){
                        selectedView = 2
                    }
                    Button("Reports"){
                        selectedView = 1
                    }
                    Button("Reminders"){
                        selectedView = 3
                    }
                    Button("Pets"){
                        
                    }
                    NavigationLink(
                        destination: ReportsView(),
                        tag: 1, selection: $selectedView
                    ) {
                        EmptyView()
                    }
                    NavigationLink(
                        destination: ManageReportsView(petId: petId),
                        tag: 2, selection: $selectedView
                    ) {
                        EmptyView()
                    }
                    NavigationLink(
                        destination: RemindersView(),
                        tag: 3, selection: $selectedView
                    ) {
                        EmptyView()
                    }
                    
                }
            }
        
}
