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
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Pet Image
            if let uiImage = selectedImage {
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
            } else if pet.photoUri != "", let url = URL(string: pet.photoUri),
                      let imageData = try? Data(contentsOf: url),
                      let image = UIImage(data: imageData) {
                Image(uiImage: image)
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
                Button(action: { showImagePicker = true }) {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 1)
                        .frame(height: 200)
                        .overlay(Text("Add Photo"))
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
                    let updatedPet = Pet(
                        id: pet.id,
                        name: name,
                        type: type,
                        description: "",
                        userId: 1,
                        photoUri: selectedImage != nil ? saveImage(selectedImage!) : pet.photoUri
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
    
    private func saveImage(_ image: UIImage) -> String {
        // Example saving logic, you can customize this path
        let filename = "pet_\(Int(Date().timeIntervalSince1970)).jpg"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: url)
        }
        return url.absoluteString
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
