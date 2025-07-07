//
//  PetsScreenView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

import SwiftUI

struct PetsScreenView : View{
    @StateObject var petViewModel = PetViewModel()
    @StateObject var userViewModel = UserViewModel()
    @State private var selectedPet: Pet? = nil
    @State private var showPetDialog = false
    
    var body : some View{
            VStack{
                Button("Add Pet"){
                    self.selectedPet = Pet(id: 0, name: "", type: "", description: "",
                                           userId : userViewModel.currentUser?.id ?? 1, photoUri: "")
                    showPetDialog = true
                }
                Text("My Pets")
                List(petViewModel.pets, id: \.id) { item in
                    //TODO: Make pretty
                    Button(action: {
                        print("Selected pet: \(item.name)")
                        self.selectedPet = item
                        showPetDialog = true
                    }) {
                        Text(item.name)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }.onAppear(){
                petViewModel.LoadPetsForUser(user_id: userViewModel.currentUser?.id ?? 1)
            }
            .sheet(item: $selectedPet) { pet in
                        EditPetDialog(
                            pet: pet,
                            petViewModel: petViewModel
                        )
                    }
        
    }
}
