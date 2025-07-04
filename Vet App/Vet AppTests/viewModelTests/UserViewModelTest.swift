//
//  UserViewModelTest.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-04.
//

import Testing
@testable import Vet_App

struct UserViewModelTests {
    @Test
    func testInsertUser() async throws {
        let mockRepo = MockUserRepository()
        let viewModel = UserViewModel(userRepository: mockRepo)

        let user = User(id: 1, name: "John", surName: "Doe", email: "john@example.com")
        let resultId = viewModel.insertUser(user: user)

        #expect(resultId == 1)
        #expect(mockRepo.insertedUsers.count == 1)
        #expect(mockRepo.insertedUsers.first?.name == "John")
    }

    @Test
    func testGetUsers() async throws {
        let mockRepo = MockUserRepository()
        mockRepo.fakeUsers = [
            User(id: 1, name: "Alice", surName: "Smith", email: "alice@example.com"),
            User(id: 2, name: "Bob", surName: "Jones", email: "bob@example.com")
        ]

        let viewModel = UserViewModel(userRepository: mockRepo)
        viewModel.getUsers()

        #expect(viewModel.users.count == 2)
        #expect(viewModel.name == "Alice")
    }

    @Test
    func testInitialCurrentUser() async throws {
        let mockRepo = MockUserRepository()
        let firstUser = User(id: 1, name: "Charlie", surName: "Brown", email: "charlie@example.com")
        mockRepo.fakeUsers = [firstUser]

        let viewModel = UserViewModel(userRepository: mockRepo)

        #expect(viewModel.currentUser?.name == "Charlie")
    }
}

