//
//  AppHeader.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-04.
//import SwiftUI
import SwiftUI

struct AppHeader: View {
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    var currentRoute: String
    var onBackOrHome: () -> Void
    var onProfile: () -> Void

    var body: some View {
        HStack {
            Button(action: onBackOrHome) {
                Image(systemName: currentRoute != "dashboard" ? "arrow.backward" : "house.fill")
                    .foregroundColor(.white)
            }

            Spacer()

            HStack(spacing: 8) {
                Text(userViewModel.currentUser?.name ?? "Guest")
                    .foregroundColor(.white)

                Button(action: onProfile) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.purple.opacity(0.7))
    }
}
