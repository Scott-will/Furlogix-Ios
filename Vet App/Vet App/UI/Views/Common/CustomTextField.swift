//
//  CustomTextField.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-09.
//
// Reusable Custom TextField Component

import SwiftUI

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

