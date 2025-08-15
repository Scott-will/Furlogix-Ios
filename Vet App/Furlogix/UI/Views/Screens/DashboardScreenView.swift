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
        BackgroundGradient()

        ScrollView {
          LazyVStack(spacing: 16) {
            // Header Section
            headerSection

            // Pet Cards
            ForEach(petViewModel.pets, id: \.id) { pet in
              PetCard(pet: pet) {
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

      Text(
        "\(petViewModel.pets.count) adorable companion\(petViewModel.pets.count != 1 ? "s" : "")"
      )
      .font(.system(size: 16))
      .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
      .multilineTextAlignment(.center)
      .padding(.top, 4)
    }
    .frame(maxWidth: .infinity)
  }
}
