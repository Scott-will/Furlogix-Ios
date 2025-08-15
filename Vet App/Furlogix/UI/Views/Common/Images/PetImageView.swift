//
//  PetImageView.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-14.
//

import SwiftUI

struct PetImageView: View {
    var petPhoto : String
    var imageHandler : ImageHandler
    @Binding var selectedImage: UIImage?    
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
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
            } else if !petPhoto.isEmpty,
                      let existingImage = imageHandler.loadImage(from: petPhoto) {
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
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }
}
