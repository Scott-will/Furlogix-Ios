//
//  PetViewModelTest.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-07.
//

import Testing
@testable import Furlogix

struct PetViewModelTest {
    @Test
    func testLoadPetsForUser_success() async throws {
        let mockRepo = MockPetRepository()
        mockRepo.fakePets = [
            Pet(id: 1, name: "Buddy", type: "Dog", description: "", userId: 1, photoUri: ""),
            Pet(id: 2, name: "Whiskers", type: "Cat", description: "", userId: 1, photoUri: "")
        ]

        let viewModel = PetViewModel(petRepository: mockRepo)
        viewModel.LoadPetsForUser(user_id: 1)

        #expect(viewModel.pets.count == 2)
        #expect(viewModel.pets.first?.name == "Buddy")
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testLoadPetsForUser_empty() async throws {
        let mockRepo = MockPetRepository()
        mockRepo.fakePets = []

        let viewModel = PetViewModel(petRepository: mockRepo)
        viewModel.LoadPetsForUser(user_id: 1)

        #expect(viewModel.pets.isEmpty)
        #expect(viewModel.errorMessage != nil)
    }

    @Test
    func testInsertPet_success() async throws {
        let mockRepo = MockPetRepository()
        let viewModel = PetViewModel(petRepository: mockRepo)

        let pet = Pet(id: 10, name: "Charlie", type: "Dog", description: "", userId: 1, photoUri: "")
        let resultId = viewModel.InsertPet(pet: pet)

        #expect(resultId == 10)
        #expect(mockRepo.insertedPets.count == 1)
        #expect(mockRepo.insertedPets.first?.name == "Charlie")
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testInsertPet_emptyName() async throws {
        let mockRepo = MockPetRepository()
        let viewModel = PetViewModel(petRepository: mockRepo)

        let pet = Pet(id: 11, name: "", type: "Dog", description: "", userId: 1, photoUri: "")
        let resultId = viewModel.InsertPet(pet: pet)

        #expect(resultId == -1)
        #expect(viewModel.errorMessage != nil)
    }

    @Test
    func testInsertPet_failure() async throws {
        let mockRepo = MockPetRepository()
        mockRepo.insertShouldReturnNil = true

        let viewModel = PetViewModel(petRepository: mockRepo)
        let pet = Pet(id: 12, name: "Bella", type: "Cat", description: "", userId: 1, photoUri: "")
        let resultId = viewModel.InsertPet(pet: pet)

        #expect(resultId == -1)
        #expect(viewModel.errorMessage != nil)
    }

    @Test
    func testUpdatePet_success() async throws {
        let mockRepo = MockPetRepository()
        let viewModel = PetViewModel(petRepository: mockRepo)

        let pet = Pet(id: 5, name: "Max", type: "Dog", description: "", userId: 1, photoUri: "")
        let resultId = viewModel.UpdatePet(pet: pet)

        #expect(resultId == 5)
        #expect(mockRepo.updatedPets.count == 1)
        #expect(mockRepo.updatedPets.first?.name == "Max")
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testUpdatePet_emptyName() async throws {
        let mockRepo = MockPetRepository()
        let viewModel = PetViewModel(petRepository: mockRepo)

        let pet = Pet(id: 6, name: "", type: "Dog", description: "", userId: 1, photoUri: "")
        let resultId = viewModel.UpdatePet(pet: pet)

        #expect(resultId == -1)
        #expect(viewModel.errorMessage != nil)
    }

    @Test
    func testUpdatePet_failure() async throws {
        let mockRepo = MockPetRepository()
        mockRepo.updateShouldReturnNil = true

        let viewModel = PetViewModel(petRepository: mockRepo)
        let pet = Pet(id: 7, name: "Rocky", type: "Dog", description: "", userId: 1, photoUri: "")
        let resultId = viewModel.UpdatePet(pet: pet)

        #expect(resultId == -1)
        #expect(viewModel.errorMessage != nil)
    }

    @Test
    func testGetPetById_success() async throws {
        let mockRepo = MockPetRepository()
        let pet = Pet(id: 7, name: "Luna", type: "Cat", description: "", userId: 1, photoUri: "")
        mockRepo.fakePets = [pet]

        let viewModel = PetViewModel(petRepository: mockRepo)
        viewModel.GetPetById(petId: 7)

        #expect(mockRepo.fetchedPetId == 7)
        #expect(viewModel.currentpet?.name == "Luna")
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testGetPetById_failure() async throws {
        let mockRepo = MockPetRepository()
        mockRepo.fakePets = []

        let viewModel = PetViewModel(petRepository: mockRepo)
        viewModel.GetPetById(petId: 999)

        #expect(viewModel.currentpet == nil)
        #expect(viewModel.errorMessage != nil)
    }

    @Test
    func testDeletePet_success() async throws {
        let mockRepo = MockPetRepository()
        let viewModel = PetViewModel(petRepository: mockRepo)

        let result = viewModel.DeletePet(petId: 9)

        #expect(result == true)
        #expect(mockRepo.deletedPetIds.contains(9))
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testDeletePet_failure() async throws {
        let mockRepo = MockPetRepository()
        mockRepo.deleteShouldReturnFalse = true

        let viewModel = PetViewModel(petRepository: mockRepo)
        let result = viewModel.DeletePet(petId: 10)

        #expect(result == false)
        #expect(viewModel.errorMessage != nil)
    }
}
