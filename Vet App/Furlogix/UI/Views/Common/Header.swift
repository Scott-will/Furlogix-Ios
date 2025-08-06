//
//  Header.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-05.
//
import SwiftUI

struct HeaderSection: View {
    var title: String
    var subtitle: String
    @State private var headerScale: CGFloat = 0.0
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                .scaleEffect(headerScale)
                .onAppear {
                    withAnimation(.easeOut(duration: 1.0)) { headerScale = 1.0 }
                }
            
            Text(subtitle)
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
                .padding(.top, 4)
        }
        .padding(.horizontal, 20)
    }
}
