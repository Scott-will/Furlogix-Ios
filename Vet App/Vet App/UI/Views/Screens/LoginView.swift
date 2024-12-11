//
//  LoginView.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-09.
//

import SwiftUI


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
