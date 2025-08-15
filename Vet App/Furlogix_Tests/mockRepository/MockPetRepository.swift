//
//  MockPetRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-07.
//
import Foundation

@testable import Furlogix

class MockPetRepository: PetRepositoryProtocol {
  var fakePets: [Pet] = []
  var insertedPets: [Pet] = []
  var updatedPets: [Pet] = []
  var deletedPetIds: [Int64] = []
  var fetchedPetId: Int64?

  var insertShouldReturnNil = false
  var updateShouldReturnNil = false
  var deleteShouldReturnFalse = false

  func GetPetsForUser(id: Int64) -> [Pet] {
    return fakePets
  }

  func InsertPet(pet: Pet) -> Int64? {
    if insertShouldReturnNil { return nil }
    insertedPets.append(pet)
    return pet.id
  }

  func UpdatePet(pet: Pet) -> Int64? {
    if updateShouldReturnNil { return nil }
    updatedPets.append(pet)
    return pet.id
  }

  func GetPet(id: Int64) -> Pet? {
    fetchedPetId = id
    return fakePets.first { $0.id == id }
  }

  func DeletePet(id: Int64) -> Bool {
    if deleteShouldReturnFalse { return false }
    deletedPetIds.append(id)
    return true
  }
}
