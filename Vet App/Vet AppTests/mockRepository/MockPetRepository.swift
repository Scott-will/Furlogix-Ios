//
//  MockPetRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-07.
//
import Foundation
@testable import Vet_App

class MockPetRepository: PetRepositoryProtocol {
    var fakePets: [Pet] = []
    var insertedPets: [Pet] = []
    var updatedPets: [Pet] = []
    var deletedPetIds: [Int64] = []
    var fetchedPetId: Int64?

    func GetPetsForUser(id: Int64) -> [Pet] {
        return fakePets
    }

    func InsertPet(pet: Pet) -> Int64? {
        insertedPets.append(pet)
        return pet.id
    }

    func UpdatePet(pet: Pet) -> Int64? {
        updatedPets.append(pet)
        return pet.id
    }

    func GetPet(id: Int64) -> Pet? {
        fetchedPetId = id
        return fakePets.first { $0.id == id }
    }

    func DeletePet(id: Int64) -> Bool {
        deletedPetIds.append(id)
        return true
    }
}
