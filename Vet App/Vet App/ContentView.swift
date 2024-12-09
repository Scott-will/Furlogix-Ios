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
struct LoginView: View {
    @State private var vetID: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 50)
            
            VStack(spacing: 30) {
                CustomTextField(placeholder: "Vet I.D", text: $vetID)
                CustomTextField(placeholder: "Email address", text: $email)
                CustomTextField(placeholder: "Password", text: $password, isSecure: true)
            }
            .padding(.horizontal, 20)
            
            Button(action: {
                // Add Login action here
            }) {
                Text("Login")
                    .font(Font.custom("Inter", size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            
            Button(action: {
                // Add Forgot Passcode action here
            }) {
                Text("Forgot passcode?")
                    .font(Font.custom("Inter", size: 17))
                    .foregroundColor(Color(red: 0.57, green: 0.82, blue: 0.93))
            }
            
            Spacer()
            
            HStack {
                Text("Don’t have an account?")
                    .foregroundColor(.gray)
                NavigationLink(destination: SignUpView()) {
                    Text("Sign-up")
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Login")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .background(Color.white.ignoresSafeArea())
    }
}

// Sign-up Screen
struct SignUpView: View {
    @State private var vetID: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                CustomTextField(placeholder: "Vet I.D", text: $vetID)
                CustomTextField(placeholder: "First Name", text: $firstName)
                CustomTextField(placeholder: "Last Name", text: $lastName)
                CustomTextField(placeholder: "Email", text: $email)
                CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                CustomTextField(placeholder: "Phone Number", text: $phoneNumber)
                CustomTextField(placeholder: "Address", text: $address)
                
                HStack(spacing: 20) {
                    Button("Cancel") {
                        // Cancel action
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Next") {
                        // Next action
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Sign-up")
        .background(Color.white.ignoresSafeArea())
    }
}

// Reusable Custom TextField Component
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .padding()
                .background(Color(red: 246 / 255, green: 246 / 255, blue: 246 / 255))
                .cornerRadius(8)
        } else {
            TextField(placeholder, text: $text)
                .padding()
                .background(Color(red: 246 / 255, green: 246 / 255, blue: 246 / 255))
                .cornerRadius(8)
        }
    }
}

