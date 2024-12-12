//
//  ContentView.swift
//  New Vet App
//
//  Created by Daylyn Kokeza on 2024-12-08.
//

import SwiftUI

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
                        .accessibilityLabel("Log in to your account")
                }
                .padding(.horizontal, 20)
                
                NavigationLink(destination: SignUpView()) {
                    Text("Sign-up")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .accessibilityLabel("Create a new account")
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Home")
        }
    }
}

// Login Screen
struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            CustomTextField(placeholder: "Email", text: $email)
            CustomTextField(placeholder: "Password", text: $password, isSecure: true)
            
            Button(action: {
                // Add login action here
            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            
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
        .padding()
        .navigationTitle("Login")
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
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @FocusState private var focusedField: Field?
    
    @State private var navigateToAddPet = false  // State to control navigation
    
    enum Field: Hashable {
        case vetID, firstName, lastName, email, password, phoneNumber, address
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                CustomTextField(placeholder: "Vet I.D", text: $vetID)
                    .focused($focusedField, equals: .vetID)
                    .submitLabel(.next)
                
                CustomTextField(placeholder: "First Name", text: $firstName)
                    .focused($focusedField, equals: .firstName)
                    .submitLabel(.next)
                
                CustomTextField(placeholder: "Last Name", text: $lastName)
                    .focused($focusedField, equals: .lastName)
                    .submitLabel(.next)
                
                CustomTextField(placeholder: "Email", text: $email)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                
                CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                
                CustomTextField(placeholder: "Phone Number", text: $phoneNumber)
                    .focused($focusedField, equals: .phoneNumber)
                    .submitLabel(.next)
                
                CustomTextField(placeholder: "Address", text: $address)
                    .focused($focusedField, equals: .address)
                    .submitLabel(.done)
                
                HStack(spacing: 20) {
                    Button("Cancel") {
                        // Cancel action
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Next") {
                        if vetID.isEmpty || firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
                            showError = true
                            errorMessage = "Please fill in all required fields."
                        } else {
                            navigateToAddPet = true  // Set state to navigate to Add Pet screen
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.top, 20)
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
            .padding()
            
            // New NavigationDestination to ContentView when navigateToAddPet is true
            .navigationDestination(isPresented: $navigateToAddPet) {
                ContentView() // Navigate to Add Pet screen
            }
        }
        .navigationTitle("Sign-up")
    }
}

// Add Pet Screen (ContentView)
struct ContentView: View {
    @State private var petName: String = ""
    @State private var weight: String = ""
    @State private var coatColor: String = ""
    @State private var medicalConditions: String = ""
    @State private var breed: String = ""
    
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case petName, weight, coatColor, medicalConditions, breed
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Add a Pet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                CustomTextField(placeholder: "Pet Name", text: $petName)
                    .focused($focusedField, equals: .petName)
                    .submitLabel(.next)
                
                CustomTextField(placeholder: "Weight (kg)", text: $weight)
                    .focused($focusedField, equals: .weight)
                    .submitLabel(.next)
                
                CustomTextField(placeholder: "Coat Color", text: $coatColor)
                    .focused($focusedField, equals: .coatColor)
                    .submitLabel(.next)
                
                CustomTextField(placeholder: "Medical Conditions", text: $medicalConditions)
                    .focused($focusedField, equals: .medicalConditions)
                    .submitLabel(.next)
                
                CustomTextField(placeholder: "Breed", text: $breed)
                    .focused($focusedField, equals: .breed)
                    .submitLabel(.done)
                
                HStack(spacing: 20) {
                    Button("Cancel") {
                        // Cancel action
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Save Pet") {
                        // Validate inputs
                        if petName.isEmpty || weight.isEmpty || coatColor.isEmpty || medicalConditions.isEmpty || breed.isEmpty {
                            showError = true
                            errorMessage = "Please fill in all required fields."
                        } else {
                            // Perform save action here
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.top, 20)
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
            .padding()
        }
        .navigationTitle("Pet Information")
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
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
        } else {
            TextField(placeholder, text: $text)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
