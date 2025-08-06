//
//  PetDetailsView.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-05.
//

import SwiftUI
import PhotosUI

struct PetDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var type: String
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @ObservedObject private var petViewModel = PetViewModel()
    
    var pet: Pet
    var isNewPet: Bool { pet.id == 0 }
    var onSave: (Pet) -> Void
    var onDelete: () -> Void
    
    private let imageHandler = ImageHandler()
    
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
            if let uiImage = selectedImage {
                // Show newly selected image
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(alignment: .bottomTrailing) {
                        Button(action: { showImagePicker = true }) {
                            Text("Edit Photo")
                                .padding(6)
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(8)
                        }
                    }
            } else if !pet.photoUri.isEmpty, let existingImage = imageHandler.loadImage(from: pet.photoUri){
                // Show existing image from storage
                
                Image(uiImage: existingImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(alignment: .bottomTrailing) {
                        Button(action: { showImagePicker = true }) {
                            Text("Edit Photo")
                                .padding(6)
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(8)
                        }
                    }
            } else {
                // No image placeholder
                Button(action: { showImagePicker = true }) {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 1)
                        .frame(height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                                Text("Add Photo")
                                    .foregroundColor(.blue)
                            }
                        )
                }
            }
            
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
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
