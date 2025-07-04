//
//  RootView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-04.
//
import SwiftUI

struct RootView: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var path = NavigationPath()
    @State private var routeStack: [String] = []

    var body: some View {
        
            

            NavigationStack(path: $path) {
                VStack(spacing: 0) {
                AppHeader(
                    currentRoute: currentRoute,
                    onBackOrHome: { popRoute() },
                    onProfile: { pushRoute("profile") }
                )
                .frame(height: 60)
                .background(Color.purple)
                contentView()
                    .navigationDestination(for: String.self) { route in
                        switch route {
                        case let petRoute where petRoute.starts(with: "pet/"):
                            if let petId = Int64(petRoute.dropFirst(4)) {
                                PetDashbaordView(petId: petId)
                            } else {
                                Text("Invalid pet id")
                            }
                        default:
                            Text("Unknown route")
                        }
                    }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }

    private var currentRoute: String {
        routeStack.last ?? "dashboard"
    }

    private func pushRoute(_ route: String) {
        path.append(route)
        routeStack.append(route)
    }

    private func popRoute() {
        if !routeStack.isEmpty {
            routeStack.removeLast()
            path.removeLast()
        }
    }

    @ViewBuilder
    private func contentView() -> some View {
        if routeStack.isEmpty {
            DashbaordView()
        } else {
            Text("Loading...")
        }
    }
}
