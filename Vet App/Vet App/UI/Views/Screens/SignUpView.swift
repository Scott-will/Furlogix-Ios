//
//  SignUpView.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-09.
//

import SwiftUI


struct SignUpView: View {

    @ObservedObject var viewModel = UserViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                CustomTextField(placeholder: "First Name", text: $viewModel.name)
                CustomTextField(placeholder: "Last Name", text: $viewModel.surName)
                CustomTextField(placeholder: "Email", text: $viewModel.email)
                CustomTextField(placeholder: "Pet Name", text: $viewModel.petName)
                
                HStack(spacing: 20) {
                    Button("Cancel") {
                        // Cancel action
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Next") {
                        viewModel.getUsers()
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
