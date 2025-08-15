//
//  FieldType.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

enum FieldType: Int, Codable, CaseIterable, Identifiable {
  case Text
  case Number
  case Boolean

  var id: Int { self.rawValue }

  var displayName: String {
    switch self {
    case .Text: return "Text"
    case .Number: return "Number"
    case .Boolean: return "Boolean"
    }
  }
}
