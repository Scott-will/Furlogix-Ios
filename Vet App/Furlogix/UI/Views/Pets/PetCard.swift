//
//  PetCard.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-06.
//

import SwiftUI

struct PetCard: View {
    let pet: Pet
    let onClick: () -> Void
    @State private var isPressed = false
    private let imageHandler = ImageHandler()
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = true
            }
            onClick()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = false
                }
            }
        }) {
            ZStack {
                // Card background
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                
                // Gradient background overlay
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.1),
                                Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 140)
                
                HStack(spacing: 20) {
                    ZStack {
                        // Updated image loading logic
                        if !pet.photoUri.isEmpty, let localImage = imageHandler.loadImage(from: pet.photoUri) {
                            Image(uiImage: localImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            petPlaceholder
                        }
                        
                        // Online indicator
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.06, green: 0.73, blue: 0.51))
                                        .frame(width: 24, height: 24)
                                    
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 8, height: 8)
                                }
                            }
                        }
                        .frame(width: 100, height: 100)
                    }
                    
                    // Pet Info
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(pet.name)
                                .font(.custom("Rubik-Bold", size: 24))
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                            Spacer()
                        }
                        
                        HStack {
                            Text("Tap to view details")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    
                    // Arrow indicator
                    Image(systemName: "chevron.right")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.72))
                }
                .padding(20)
            }
            .frame(height: 140)
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var petPlaceholder: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.3),
                            Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.3)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .frame(width: 100, height: 100)
            
            Image(systemName: "heart.fill")
                .font(.system(size: 40))
                .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
        }
    }
}
