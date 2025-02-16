//
//  PetDashboard.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//

import SwiftUI

struct PetDashbaordView : View{
    @StateObject var viewModel = PetViewModel()
    
    var body : some View{
        VStack{
            Text("Pet Dashboard")
            Button("Manage Reports"){
                
            }
            Button("Reports"){
                
            }
            Button("Reminders"){
                
            }
            Button("Pets"){
                
            }
        }
    }
}
