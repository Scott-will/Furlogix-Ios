//
//  EditPetDialog.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-07.
//

import SwiftUI
import PhotosUI

struct EditPetDialog : View{
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var petViewModel: PetViewModel
    @State private var selectedImage: UIImage? = nil
    @State var pet: Pet
    @State private var name: String
    @State private var type: String
    
    init(pet: Pet, petViewModel : PetViewModel){
        self._pet = State(initialValue: pet)
        self._name = State(initialValue: pet.name)
        self._type = State(initialValue: pet.type)
        self.petViewModel = petViewModel
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 16){
                /*if let image = selectedImage{
                 Image(uiImage: image)
                 .resizable()
                 .scaledToFill()
                 .frame(height: 200)
                 .clipShape(RoundedRectangle(cornerRadius: 12))
                 }else if let photoUri = pet.photoUri,
                 let url = URL(string: photoUri),
                 let data = try? Data(contentsOf: url),
                 let image = UIImage(data: data){
                 Image(uiImage: image)
                 .resizable()
                 .scaledToFill()
                 .frame(height: 200)
                 .clipShape(RoundedRectangle(cornerRadius: 12))
                 }
                 else{
                 RoundedRectangle(cornerRadius: 12)
                 .stroke(Color.blue, lineWidth: 1)
                 .frame(height: 200)
                 .overlay(
                 Text("Add Photo")
                 .font(.headline)
                 .foregroundColor(.blue)
                 .padding()
                 )
                 }*/
                
                //photo picker
                
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                TextField("Type", text: $type)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Pet Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction){
                    Button(pet.id == 0 ? "Close" : "Delete"){
                        if(pet.id == 0){
                            dismiss()
                        } else{
                            petViewModel.DeletePet(petId: pet.id)
                            petViewModel.LoadPetsForUser(user_id: 1)
                            dismiss()
                        }
                    }.foregroundColor(pet.id == 0 ? .blue: .red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var updatedPet = pet
                        updatedPet.name = name
                        updatedPet.type = type
                        if let image = selectedImage {
                            // Save image locally or upload, then set URI
                            // Here, for simplicity, we just skip it
                        }
                        if pet.id == 0 {
                            petViewModel.InsertPet(pet: updatedPet)
                            petViewModel.LoadPetsForUser(user_id: 1)
                        } else {
                            petViewModel.UpdatePet(pet: updatedPet)
                            petViewModel.LoadPetsForUser(user_id: 1)
                        }
                        dismiss()
                    }
                    .disabled(name.isEmpty || type.isEmpty)
                }
            }
        }
        .withErrorAlerts(viewModels: [petViewModel])
    }
}
