//
//  PetView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

import SwiftUI

struct DashbaordView : View{
    @StateObject var viewModel = PetViewModel()

        var body: some View {
            VStack {
                Text("PET SCREEN")
                List(viewModel.pets, id: \.name) { item in
                    Button(action: {
                        print("\(item.name) button tapped!")
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
