//
//  AppHeader.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-04.
//import SwiftUI
import SwiftUI

struct AppHeader: View {
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    @StateObject private var routeManager = RouteManager.shared


    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Text(userViewModel.currentUser?.name ?? "Guest")
                    .foregroundColor(.white)

                Button(action: {routeManager.push(.profile(userId: 1))}) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Themes.primaryColor)
    }
}
