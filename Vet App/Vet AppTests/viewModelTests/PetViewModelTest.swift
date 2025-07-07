//
//  PetViewModelTest.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-07.
//

import Testing
@testable import Vet_App

struct PetViewModelTest {
    @Test
    func testLoadPetsForUser() async throws {
        let mockRepo = MockPetRepository()
        mockRepo.fakePets = [
            Pet(id: 1, name: "Buddy", type: "Dog", description: "", userId : 1, photoUri: ""),
            Pet(id: 2, name: "Whiskers", type: "Cat", description: "", userId : 1, photoUri: "")
        ]
        
        let viewModel = PetViewModel(petRepository: mockRepo)
        viewModel.LoadPetsForUser(user_id: 123)

        #expect(viewModel.pets.count == 2)
        #expect(viewModel.pets.first?.name == "Buddy")
    }

    @Test
    func testInsertPet() async throws {
        let mockRepo = MockPetRepository()
        let viewModel = PetViewModel(petRepository: mockRepo)
        
        let pet = Pet(id: 10, name: "Charlie", type: "Dog",description: "", userId : 1, photoUri: "")
        let resultId = viewModel.InsertPet(pet: pet)

        #expect(resultId == 10)
        #expect(mockRepo.insertedPets.count == 1)
        #expect(mockRepo.insertedPets.first?.name == "Charlie")
    }

    @Test
    func testUpdatePet() async throws {
        let mockRepo = MockPetRepository()
        let viewModel = PetViewModel(petRepository: mockRepo)
        
        let pet = Pet(id: 5, name: "Max", type: "Dog", description: "", userId : 1, photoUri: "")
        let resultId = viewModel.UpdatePet(pet: pet)

        #expect(resultId == 5)
        #expect(mockRepo.updatedPets.count == 1)
        #expect(mockRepo.updatedPets.first?.name == "Max")
    }

    @Test
    func testGetPetById() async throws {
        let mockRepo = MockPetRepository()
        let pet = Pet(id: 7, name: "Luna", type: "Cat", description: "", userId : 1, photoUri: "")
        mockRepo.fakePets = [pet]
        
        let viewModel = PetViewModel(petRepository: mockRepo)
        viewModel.GetPetById(petId: 7)

        #expect(mockRepo.fetchedPetId == 7)
        #expect(viewModel.currentpet?.name == "Luna")
    }

    @Test
    func testDeletePet() async throws {
        let mockRepo = MockPetRepository()
        let viewModel = PetViewModel(petRepository: mockRepo)

        let result = viewModel.DeletePet(petId: 9)

        #expect(result == true)
        #expect(mockRepo.deletedPetIds.contains(9))
    }
}
