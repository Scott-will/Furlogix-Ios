//
//  PetView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

import SwiftUI


struct DashboardScreenView: View {
    let userId: Int64
    var onNavigate: (AppRoute) -> Void
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var petViewModel = PetViewModel()
    @State private var headerScale: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.97, green: 0.98, blue: 1.0),
                        Color(red: 0.93, green: 0.95, blue: 1.0),
                        Color(red: 0.88, green: 0.91, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Header Section
                        headerSection
                        
                        // Pet Cards
                        ForEach(petViewModel.pets, id: \.id) { pet in
                            ModernPetCard(pet: pet) {
                                onNavigate(.petDashboard(petId: pet.id))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
        }
        .onAppear {
            if userId != 0 {
                petViewModel.LoadPetsForUser(user_id: userId)
            }
            
            withAnimation(.easeInOut(duration: 1.0)) {
                headerScale = 1.0
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .center, spacing: 0) {
            // Animated header icon
            Image(systemName: "heart.fill")
                .font(.system(size: 48))
                .foregroundColor(Color(red: 0.39, green: 0.4, blue: 0.95))
                .scaleEffect(headerScale)
            
            Spacer()
                .frame(height: 12)
            
            Text("My Furry Family")
                .font(.custom("Rubik-Bold", size: 32))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                .multilineTextAlignment(.center)
            
            Text("\(petViewModel.pets.count) adorable companion\(petViewModel.pets.count != 1 ? "s" : "")")
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ModernPetCard: View {
    let pet: Pet
    let onClick: () -> Void
    @State private var isPressed = false
    
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
                        if !pet.photoUri.isEmpty {
                            AsyncImage(url: URL(string: pet.photoUri)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                petPlaceholder
                            }
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
