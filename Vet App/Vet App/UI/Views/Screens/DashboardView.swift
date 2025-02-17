//
//  PetView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

import SwiftUI

struct DashbaordView : View{
    @StateObject var viewModel = PetViewModel()
    @State private var petIdToPass : Int64 = -1
    @State private var navigateToPetDashboard = false
    
    var body: some View {
        NavigationView{
            VStack {
                Text("PET SCREEN")
                List(viewModel.pets, id: \.id) { item in
                    //TODO: Make pretty
                    Button(action: {
                        petIdToPass = item.id
                        navigateToPetDashboard = true
                    }) {
                        Text(item.name)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                NavigationLink(destination: PetDashbaordView(petId: $petIdToPass), isActive: $navigateToPetDashboard) {
                                EmptyView()
                            }
            }.onAppear(){
                viewModel.LoadPetsForUser(user_id: 1)
            }
            .padding()
        }
        
                    
    }
}
