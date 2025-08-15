//
//  CustomTextField.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-09.
//
// Reusable Custom TextField Component

import SwiftUI

struct CustomTextField: View {
  var icon: String
  var placeholder: String
  @Binding var text: String
  var keyboardType: UIKeyboardType = .default

  var body: some View {
    HStack {
      Image(systemName: icon)
        .foregroundColor(Color.gray)
        .frame(width: 20)
      TextField(placeholder, text: $text)
        .keyboardType(keyboardType)
        .font(.system(size: 16))
    }
    .padding(16)
    .background(Color.white)
    .overlay(
      RoundedRectangle(cornerRadius: 16).stroke(
        Color(red: 0.89, green: 0.91, blue: 0.94), lineWidth: 1)
    )
    .cornerRadius(16)
  }
}
