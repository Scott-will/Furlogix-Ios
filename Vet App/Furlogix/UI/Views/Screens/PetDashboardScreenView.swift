//
//  PetDashboard.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//

import SwiftUI

struct PetDashboardScreenView: View {
  let petId: Int64
  var onNavigate: (AppRoute) -> Void
  @StateObject private var userViewModel = UserViewModel()
  @StateObject private var petViewModel = PetViewModel()
  @StateObject private var reportViewModel = ReportViewModel()
  @State private var showHelp = false
  @State private var headerScale: CGFloat = 0.0

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        BackgroundGradient()

        ScrollView {
          LazyVStack(spacing: 20) {
            // Header Section
            headerSection

            // Pet Photo Card
            if let photoUri = petViewModel.currentpet?.photoUri {
              petPhotoCard(photoUri: photoUri, name: petViewModel.currentpet?.name ?? "")
            }

            // Action Cards
            actionCardsSection
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 24)
        }
      }
    }
    .onAppear {
      petViewModel.GetPetById(petId: petId)

      withAnimation(.easeInOut(duration: 1.0)) {
        headerScale = 1.0
      }
    }
    .sheet(isPresented: $showHelp) {
      //   HelpWizardView(onFinish: { showHelp = false })
    }
    /* .alert("Pending Reports", isPresented: .constant(userViewModel.currentUser?.pendingSentReports == true)) {
         Button("Confirm") {
             userViewModel.setNoPendingReportsForUser()
         }
         Button("View Reports") {
             // Navigate to reports
         }
     }*/
  }

  private var headerSection: some View {
    VStack(spacing: 4) {
      Text("\(petViewModel.currentpet?.name ?? "Pet") Dashboard")
        .font(.system(size: 32, weight: .bold))
        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
        .multilineTextAlignment(.center)
        .scaleEffect(headerScale)

      Text("Manage your pet's health and care")
        .font(.system(size: 16))
        .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
        .multilineTextAlignment(.center)
    }
  }

  private var actionCardsSection: some View {
    VStack(spacing: 16) {
      ModernActionCard(
        title: "Health Reports",
        subtitle: "Track and manage pet health",
        iconName: "calendar",
        gradient: LinearGradient(
          colors: [
            Color(red: 0.4, green: 0.49, blue: 0.92), Color(red: 0.46, green: 0.29, blue: 0.64),
          ],
          startPoint: .leading,
          endPoint: .trailing
        ),
        action: {
          onNavigate(.manageReports(petId: petId))
        }
      )

      ModernActionCard(
        title: "Reminders",
        subtitle: "Setup care alerts",
        iconName: "bell",
        gradient: LinearGradient(
          colors: [
            Color(red: 0.26, green: 0.91, blue: 0.48), Color(red: 0.22, green: 0.98, blue: 0.84),
          ],
          startPoint: .leading,
          endPoint: .trailing
        ),
        action: {
          onNavigate(.reminders)
        }
      )

      ModernActionCard(
        title: "All Pets",
        subtitle: "View your pets",
        iconName: "person",
        gradient: LinearGradient(
          colors: [
            Color(red: 0.98, green: 0.44, blue: 0.6), Color(red: 1.0, green: 0.88, blue: 0.25),
          ],
          startPoint: .leading,
          endPoint: .trailing
        ),
        action: {
          onNavigate(.pets(userId: 1))
        }
      )

      ModernActionCard(
        title: "Need Help?",
        subtitle: "Get assistance and tutorials",
        iconName: "info.circle",
        gradient: LinearGradient(
          colors: [
            Color(red: 0.4, green: 0.49, blue: 0.92), Color(red: 0.46, green: 0.29, blue: 0.64),
          ],
          startPoint: .leading,
          endPoint: .trailing
        ),
        action: {
          showHelp = true
        }
      )
    }
  }
}

struct ModernActionCard: View {
  let title: String
  let subtitle: String
  let iconName: String
  let gradient: LinearGradient
  let action: () -> Void

  @State private var isPressed = false

  var body: some View {
    Button(action: {
      withAnimation(.easeInOut(duration: 0.15)) {
        isPressed = true
      }
      action()

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
        withAnimation(.easeInOut(duration: 0.15)) {
          isPressed = false
        }
      }
    }) {
      HStack(spacing: 16) {
        // Icon with gradient background
        ZStack {
          Circle()
            .fill(gradient)
            .frame(width: 60, height: 60)

          Image(systemName: iconName)
            .font(.system(size: 28))
            .foregroundColor(.white)
        }

        // Text content
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Text(title)
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
            Spacer()
          }

          HStack {
            Text(subtitle)
              .font(.system(size: 14))
              .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
            Spacer()
          }
        }

        Spacer()
      }
      .padding(20)
      .frame(height: 120)
      .background(Color.white)
      .cornerRadius(20)
      .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
      .scaleEffect(isPressed ? 0.96 : 1.0)
    }
    .buttonStyle(PlainButtonStyle())
  }
}
