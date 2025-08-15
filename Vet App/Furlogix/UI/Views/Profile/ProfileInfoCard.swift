//
//  ProfileInfoCard.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-05.
//

import SwiftUI

struct ProfileInfoCard: View {
  @Binding var name: String
  @Binding var email: String
  var onSave: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack {
        Image(systemName: "person.fill")
          .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
          .font(.system(size: 24))
        Text("Personal Information")
          .font(.system(size: 20, weight: .bold))
        Spacer()
      }

      VStack(spacing: 16) {
        CustomTextField(icon: "person", placeholder: "Name", text: $name)
        CustomTextField(
          icon: "envelope", placeholder: "Email", text: $email, keyboardType: .emailAddress)
      }

      Button(action: onSave) {
        Label("Save Changes", systemImage: "checkmark")
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .background(Color(red: 0.02, green: 0.59, blue: 0.41))
          .foregroundColor(.white)
          .cornerRadius(16)
      }
    }
    .padding(24)
    .background(Color.white)
    .cornerRadius(24)
    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
    .padding(.horizontal, 20)
  }
}
