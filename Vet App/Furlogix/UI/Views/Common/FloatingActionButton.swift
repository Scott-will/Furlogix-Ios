//
//  FloatingActionButton.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-06.
//
import SwiftUI

struct FloatingActionButton : View {
    var onClick: () -> Void
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    onClick()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color(red: 0.4, green: 0.49, blue: 0.92))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 4)
                }
                .padding(24)
            }
        }
    }
}
