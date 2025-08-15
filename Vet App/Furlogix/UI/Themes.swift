//
//  Themes.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

import SwiftUI

struct Themes {
  // MARK: - Colors
  static let purple80 = Color(hex: 0xFFD0_BCFF)
  static let purpleGrey80 = Color(hex: 0xFFCC_C2DC)
  static let pink80 = Color(hex: 0xFFEF_B8C8)
  static let clickableItemRed = Color(hex: 0xFFCC_3232)
  static let buttonBlue = Color(hex: 0xFF8B_DEDA)

  static let purple40 = Color(hex: 0xFF66_50A4)
  static let purpleGrey40 = Color(hex: 0xFF62_5B71)
  static let pink40 = Color(hex: 0xFF7D_5260)

  static let primaryColor = Color(hex: 0xFFD0_BCFF)
  static let onPrimaryColor = Color.white
  static let background = Color(hex: 0xFF05_0404)

  // MARK: - Fonts
  static let headerFont = Font.system(size: 20, weight: .bold)
  static let bodyFont = Font.system(size: 16)
}

extension Color {
  init(hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha
    )
  }
}

struct AppButtonStyle: ButtonStyle {
  var backgroundColor: Color = Themes.primaryColor
  var foregroundColor: Color = Themes.onPrimaryColor
  var cornerRadius: CGFloat = 8

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(size: 16, weight: .semibold))
      .padding()
      .frame(maxWidth: .infinity)
      .background(backgroundColor)
      .foregroundColor(foregroundColor)
      .cornerRadius(cornerRadius)
      .scaleEffect(configuration.isPressed ? 0.96 : 1)
      .opacity(configuration.isPressed ? 0.8 : 1)
      .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
  }
}
