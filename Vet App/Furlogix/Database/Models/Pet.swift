//
//  Pet.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

struct Pet: Decodable, Identifiable {
  var id: Int64
  var name: String
  var type: String
  var description: String
  var userId: Int64
  var photoUri: String
}
