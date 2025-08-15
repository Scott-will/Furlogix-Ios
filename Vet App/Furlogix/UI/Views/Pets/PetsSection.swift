//
//  PetsSection.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-05.
//
import SwiftUI

struct PetsSection: View {
  var pets: [Pet]
  var onSelectPet: (Pet) -> Void
    var onAddPet: (Pet) -> Void
  @State private var showAddPetDialog = false

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack {
        Label("Your Pets", systemImage: "pawprint.fill")
          .font(.system(size: 20, weight: .bold))
        Spacer()
        Text("\(pets.count) \(pets.count == 1 ? "Pet" : "Pets")")
          .font(.system(size: 12, weight: .medium))
          .padding(.horizontal, 12)
          .padding(.vertical, 6)
          .background(Color.blue.opacity(0.1))
          .cornerRadius(12)
      }

      if pets.isEmpty {
        //EmptyPetView()
      } else {
        PetListView(pets: pets, onPetSelected: onSelectPet)
      }

        Button(action: {showAddPetDialog = true}) {
        Label("Add New Pet", systemImage: "plus")
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .background(Color(red: 0.4, green: 0.49, blue: 0.92))
          .foregroundColor(.white)
          .cornerRadius(16)
      }
    }
    .padding(20)
    .background(Color.white)
    .cornerRadius(24)
    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
    .padding(.horizontal, 20)
    .sheet(isPresented: $showAddPetDialog) {
                  AddPetDialog(onAdd: { pet in
                      onAddPet(pet)
                  })
              }
  }
    
}

