//
//  ContentView.swift
//  New Vet App
//
//  Created by Daylyn  Kokeza  on 2024-12-08.
//

import SwiftUI
import CoreData



// Main Entry Screen
struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to the Vet App")
                    .font(.largeTitle)
                    .padding(.bottom, 50)
                
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                NavigationLink(destination: SignUpView()) {
                    Text("Sign-up")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Home")
        }
    }
}

// Login Screen




