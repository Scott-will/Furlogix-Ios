//
//  PetPhotoCard.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-06.
//

import SwiftUI

func petPhotoCard(photoUri: String, name : String) -> some View {
    let imageHandler = ImageHandler()
    
    return ZStack {
        // Load local image or show placeholder
        Group {
            if !photoUri.isEmpty, let localImage = imageHandler.loadImage(from: photoUri) {
                Image(uiImage: localImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.3),
                                Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        VStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                            
                            Text("No Photo")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                                .padding(.top, 8)
                        }
                    )
            }
        }
        .frame(height: 240)
        .clipped()
        
        // Gradient overlay (only show when there's an actual image)
        if !photoUri.isEmpty && imageHandler.loadImage(from: photoUri) != nil {
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        
        // Pet name overlay
        VStack {
            Spacer()
            HStack {
                Text(name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                    .padding(.bottom, 20)
                Spacer()
            }
        }
    }
    .background(Color.white)
    .cornerRadius(24)
    .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
}
