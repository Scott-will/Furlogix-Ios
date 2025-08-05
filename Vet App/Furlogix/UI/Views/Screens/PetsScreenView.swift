//
//  PetsScreenView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

import SwiftUI

struct PetsScreenView: View {
    var onNavigate: (AppRoute) -> Void
    @StateObject private var petViewModel = PetViewModel()
    @State private var selectedPet: Pet?
    @State private var showConfirmDelete = false
    @State private var headerScale: CGFloat = 0.5
    
    let userId: Int64
    
    var body: some View {
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
                LazyVStack(spacing: 20) {
                    // Header Section
                    VStack {
                        Text("My Pets")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                            .scaleEffect(headerScale)
                            .onAppear {
                                withAnimation(.easeOut(duration: 1.0)) {
                                    headerScale = 1.0
                                }
                            }
                        
                        Text("Manage your beloved companions")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
                            .padding(.top, 4)
                    }
                    .padding(.horizontal, 20)
                    
                    // Quick Actions Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(Color(red: 0.02, green: 0.59, blue: 0.41))
                                .font(.system(size: 24))
                            
                            Text("Quick Actions")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                            
                            Spacer()
                        }
                        
                        Button(action: {
                            onNavigate(.addPet(userId: 1))
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                                
                                Text("Add New Pet")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.02, green: 0.59, blue: 0.41))
                            .cornerRadius(16)
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)
                    
                    // Pets List Card
                    VStack(alignment: .leading, spacing: 16) {
                        if petViewModel.pets.isEmpty {
                            // Empty state
                            VStack(spacing: 20) {
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.72))
                                
                                VStack(spacing: 8) {
                                    Text("No Pets Yet")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
                                    
                                    Text("Add your first furry friend to get started!")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.72))
                                        .multilineTextAlignment(.center)
                                }
                                
                                Button(action: {
                                    onNavigate(.addPet(userId: 1))
                                }) {
                                    HStack {
                                        Image(systemName: "plus")
                                            .font(.system(size: 18))
                                        
                                        Text("Add Your First Pet")
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color(red: 0.4, green: 0.49, blue: 0.92))
                                    .cornerRadius(16)
                                }
                            }
                            .padding(.vertical, 40)
                        } else {
                            // Pets list header
                            HStack {
                                HStack {
                                    Image(systemName: "pawprint.fill")
                                        .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                                        .font(.system(size: 24))
                                    
                                    Text("Your Pets")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Text("\(petViewModel.pets.count) \(petViewModel.pets.count == 1 ? "Pet" : "Pets")")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.1))
                                        .cornerRadius(12)
                                }
                            }
                            
                            // Pets grid
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 16) {
                                ForEach(petViewModel.pets) { pet in
                                    ModernPetCard(pet: pet) {
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
                    .padding(.horizontal, 20)
                    
                    // Statistics Card (if pets exist)
                    if !petViewModel.pets.isEmpty {
                        HStack {
                            // Total pets stat
                            VStack {
                                Text("\(petViewModel.pets.count)")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color(red: 0.02, green: 0.59, blue: 0.41))
                                
                                Text("Total Pets")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
                            }
                            
                            Spacer()
                            
                            // Divider
                            Rectangle()
                                .fill(Color(red: 0.89, green: 0.91, blue: 0.94))
                                .frame(width: 1, height: 60)
                            
                            Spacer()
                            
                            // Pet types
                            VStack {
                                Text("\(Set(petViewModel.pets.map { $0.type }).count)")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color(red: 0.23, green: 0.51, blue: 0.96))
                                
                                Text("Pet Types")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
                            }
                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.26, green: 0.91, blue: 0.48).opacity(0.05),
                                    Color(red: 0.22, green: 0.98, blue: 0.84).opacity(0.1)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 24)
                .padding(.bottom, 100)
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        onNavigate(.addPet(userId: 1))
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(red: 0.02, green: 0.59, blue: 0.41))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 6)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .onAppear {
            petViewModel.LoadPetsForUser(user_id: userId)
        }
        .sheet(item: $selectedPet) { pet in
            PetDetailsView(pet: pet,
                           onSave: {_ in petViewModel.InsertPet(pet: pet)},
                           onDelete: {showConfirmDelete = true}

            )
        }
        .alert("Delete Pet", isPresented: $showConfirmDelete) {
            Button("Delete", role: .destructive) {
                if let pet = selectedPet {
                    petViewModel.DeletePet(petId: pet.id)
                    selectedPet = nil
                }
            }
            Button("Cancel", role: .cancel) {
                showConfirmDelete = false
            }
        } message: {
            Text("Are you sure you want to delete this pet? This action cannot be undone.")
        }
    }
}
