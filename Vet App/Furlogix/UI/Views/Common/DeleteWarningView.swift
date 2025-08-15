//
//  DeleteWarningView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-08.
//
import SwiftUI

struct DeleteWarningView: View {
  let onDismiss: () -> Void
  let onConfirm: () -> Void
  let message: String

  var body: some View {
    VStack(alignment: .center, spacing: 8) {
      Text(message)
        .font(.footnote)
        .multilineTextAlignment(.center)
        .foregroundColor(.red)

      HStack(spacing: 16) {
        Button("Cancel") {
          onDismiss()
        }
        .foregroundColor(.blue)

        Button("Delete") {
          onConfirm()
        }
        .foregroundColor(.red)
      }
    }
    .padding()
    .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(Color.red, lineWidth: 1)
    )
  }
}
