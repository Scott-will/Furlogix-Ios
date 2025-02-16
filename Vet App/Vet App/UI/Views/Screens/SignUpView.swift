//
//  SignUpView.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-09.
//

import SwiftUI


struct SignUpView: View {

    @ObservedObject var userViewModel = UserViewModel()
    @ObservedObject var petViewModel = PetViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                CustomTextField(placeholder: "First Name", text: $userViewModel.name)
                CustomTextField(placeholder: "Last Name", text: $userViewModel.surName)
                CustomTextField(placeholder: "Email", text: $userViewModel.email)
                CustomTextField(placeholder: "Pet Name", text: $userViewModel.petName)
                CustomTextField(placeholder: "Pet type", text: $userViewModel.petName)
                
                HStack(spacing: 20) {
                    Button("Cancel") {
                        // Cancel action
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Submit") {
                        let user = User(id: -1, name: userViewModel.name, surName: userViewModel.surName, email: userViewModel.email)
                        let userId = userViewModel.insertUser(user : user)
                        let pet = Pet(id: -1, name: userViewModel.petName, type: userViewModel.petType, description: "", userId: userId)
                        petViewModel.InsertPet(pet: pet)
                        
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
