//
//  PetView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

import SwiftUI

struct DashbaordScreenView : View{
    @StateObject var viewModel = PetViewModel()
    var onNavigate: (AppRoute) -> Void
    
    var body: some View {
        VStack {
                    Text("PET SCREEN")
                    List(viewModel.pets, id: \.id) { item in
                        //TODO: Make pretty
                        Button(action: {
                            onNavigate(.petDashboard(petId: item.id))
                        }) {
                            Text(item.name)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }.onAppear(){
                    viewModel.LoadPetsForUser(user_id: 1)
                }
                .padding()
            }
}
