//
//  BackgroundGradient.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-05.
//
import SwiftUI

struct BackgroundGradient: View {
  var body: some View {
    LinearGradient(
      colors: [
        Color(red: 0.97, green: 0.98, blue: 1.0),
        Color(red: 0.93, green: 0.95, blue: 1.0),
        Color(red: 0.88, green: 0.91, blue: 1.0),
      ],
      startPoint: .top,
      endPoint: .bottom
    )
    .ignoresSafeArea()
  }
}
