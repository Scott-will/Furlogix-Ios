//
//  DangerZone.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-05.
//
import SwiftUI

struct DangerZoneCard: View {
    var onDeleteAccount: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Danger Zone", systemImage: "exclamationmark.triangle.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(red: 0.86, green: 0.15, blue: 0.15))
            Text("Once you delete your account, there is no going back. Please be certain.")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.6, green: 0.11, blue: 0.11))
            Button(action: onDeleteAccount) {
                Label("Delete Account", systemImage: "trash.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.94, green: 0.27, blue: 0.27))
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
        }
        .padding(24)
        .background(Color(red: 0.99, green: 0.95, blue: 0.95))
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}
