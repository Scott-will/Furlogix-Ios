//
//  AddPetDialog.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-14.
//

import SwiftUI
        
struct AddPetDialog: View {
    @State private var name: String = ""
    @State private var type: String = ""
    let onAdd: (Pet) -> Void
    @State private var selectedImage: UIImage?
   var imageHandler = ImageHandler()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                PetImageView(petPhoto: "", imageHandler: imageHandler, selectedImage: $selectedImage)
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                TextField("Type", text: $type)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Add Pet")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button("Close") { dismiss() },
                trailing: Button("Save") {
                    var photoUri = ""
                    if let selectedImage = selectedImage {
                      photoUri = imageHandler.saveImage(selectedImage) ?? ""
                    }
                    let pet = Pet(id: 0, name: name, type: type, description: "", userId: 1, photoUri: photoUri)
                    onAdd(pet)
                    dismiss()
                }.disabled(name.isEmpty)
            )
        }
    }
}
