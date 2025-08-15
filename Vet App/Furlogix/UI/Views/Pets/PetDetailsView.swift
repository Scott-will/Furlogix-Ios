//
//  PetDetailsView.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-05.
//

import SwiftUI

struct PetDetailsView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var name: String
  @State private var type: String
  @State private var selectedImage: UIImage?
  @ObservedObject private var petViewModel = PetViewModel()
 var imageHandler = ImageHandler()
    
  var pet: Pet
  var isNewPet: Bool { pet.id == 0 }
  var onSave: (Pet) -> Void
  var onDelete: () -> Void


  init(pet: Pet, onSave: @escaping (Pet) -> Void, onDelete: @escaping () -> Void) {
    self.pet = pet
    self.onSave = onSave
    self.onDelete = onDelete
    _name = State(initialValue: pet.name)
    _type = State(initialValue: pet.type)
    AppLogger.debug("saved uri : \(pet.photoUri)")
  }

  var body: some View {
    VStack(spacing: 16) {
      // Pet Image
        PetImageView(petPhoto: self.pet.photoUri, imageHandler: imageHandler, selectedImage: $selectedImage)

      TextField("Name", text: $name)
        .textFieldStyle(.roundedBorder)

      TextField("Type", text: $type)
        .textFieldStyle(.roundedBorder)

      HStack {
        Button(isNewPet ? "Close" : "Delete", role: isNewPet ? .cancel : .destructive) {
          if isNewPet {
            dismiss()
          } else {
            onDelete()
            dismiss()
          }
        }

        Spacer()

        Button("Save") {
          var photoUri = pet.photoUri
          // Save new image if one was selected
          if let selectedImage = selectedImage {
            photoUri = imageHandler.saveImage(selectedImage) ?? pet.photoUri
          }
          AppLogger.debug(photoUri)
          let updatedPet = Pet(
            id: pet.id,
            name: name,
            type: type,
            description: pet.description,
            userId: 1,
            photoUri: photoUri
          )
          onSave(updatedPet)
          dismiss()
        }
        .disabled(name.isEmpty || type.isEmpty)
      }
    }
    .padding()
    
  }
}
