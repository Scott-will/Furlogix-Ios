//
//  SignUpView.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-09.
//

import SwiftUI


struct SignUpScreenView: View {
    var onNavigate : (AppRoute) -> Void
    @ObservedObject var userViewModel = UserViewModel()
    @ObservedObject var petViewModel = PetViewModel()
    @State private var showErrorAlert = false
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                CustomTextField(icon: "", placeholder: "First Name", text: $userViewModel.name)
                CustomTextField(icon: "",placeholder: "Last Name", text: $userViewModel.surName)
                CustomTextField(icon: "",placeholder: "Email", text: $userViewModel.email)
                CustomTextField(icon: "",placeholder: "Pet Name", text: $userViewModel.petName)
                CustomTextField(icon: "",placeholder: "Pet type", text: $userViewModel.petType)
                
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
                        if(userId != -1){
                            let pet = Pet(id: -1, name: userViewModel.petName, type: userViewModel.petType, description: "", userId: userId, photoUri: "")
                            let result = petViewModel.InsertPet(pet: pet)
                            if(result != -1){
                                onNavigate(AppRoute.dashboard(userId: userId))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    }
                }
                .padding(.top, 20)
            }
            .padding()
            .withErrorAlerts(viewModels: [userViewModel, petViewModel])

        }
    
        private func errorMessageText() -> String {
            return userViewModel.errorMessage ?? petViewModel.errorMessage ?? "Unknown error"
        }

        private func clearErrors() {
            userViewModel.errorMessage = nil
            petViewModel.errorMessage = nil
        }
    
}
