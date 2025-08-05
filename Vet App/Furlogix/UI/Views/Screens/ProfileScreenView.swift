//
//  ProfileScreen.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

import SwiftUI

struct ProfileScreenView: View {
    var onNavigate: (AppRoute) -> Void

    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var petViewModel = PetViewModel()
    @State private var name = ""
    @State private var email = ""
    @State private var selectedPet: Pet?
    @State private var showConfirmDelete = false
    @State private var showDeleteConfirmation = false
    @State private var headerScale: CGFloat = 0.5
    
    let userId: Int64    
    var body: some View {
        ZStack {
            BackgroundGradient()
            ScrollView {
                LazyVStack(spacing: 20) {
                    HeaderSection(headerScale: $headerScale)
                    ProfileInfoCard(name: $name, email: $email, onSave: {})
                    PetsSection(pets: petViewModel.pets, onSelectPet: { pet in selectedPet = pet }, onAddPet: {})
                    DangerZoneCard(onDeleteAccount: { showDeleteConfirmation = true })
                }
                .padding(.vertical, 24)
            }
        }
        .onAppear(){
            petViewModel.LoadPetsForUser(user_id: 1)
            userViewModel.getUsers()
        }
        .onChange(of: userViewModel.name) { name = $0 }
        .onChange(of: userViewModel.email) { email = $0 }
        .sheet(item: $selectedPet) { pet in
            PetDetailsView(
                pet: pet,
                onSave: { updatedPet in
                    // handle updated pet, maybe save it to DB or update UI
                    print("Pet saved: \(updatedPet.name)")
                },
                onDelete: {
                    showConfirmDelete = true
                }
            )
        }

        .alert("Delete Account", isPresented: $showDeleteConfirmation) {
           // Button("Delete Forever", role: .destructive) { userViewModel.() }
            Button("Cancel", role: .cancel) { showDeleteConfirmation = false }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone and will remove all your data including pets and reports.")
        }
        .alert("Delete Pet", isPresented: $showConfirmDelete) {
            Button("Delete", role: .destructive) { petViewModel.DeletePet(petId: 1, ) }
            Button("Cancel", role: .cancel) { showConfirmDelete = false }
        } message: {
            Text("Are you sure you want to delete this pet? This action cannot be undone.")
        }
    }

}

struct PetListView: View {
    let pets: [Pet]
    let onPetSelected: (Pet) -> Void
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ], spacing: 8) {
            ForEach(pets) { pet in
                Button(action: {
                    onPetSelected(pet)
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        AsyncImage(url: URL(string: pet.photoUri ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.1))
                                .overlay(
                                    Image(systemName: "pawprint.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                                )
                        }
                        .frame(height: 80)
                        .clipped()
                        .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(pet.name)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                                .lineLimit(1)
                            
                            Text(pet.type)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                    .padding(12)
                    .background(Color(red: 0.98, green: 0.98, blue: 0.99))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.89, green: 0.91, blue: 0.94), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
