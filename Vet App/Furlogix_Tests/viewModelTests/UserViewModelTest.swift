//
//  UserViewModelTest.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-04.
//

import Testing
@testable import Furlogix

struct UserViewModelTests {
    @Test
    func testInsertUser_success() async throws {
        let mockRepo = MockUserRepository()
        let viewModel = UserViewModel(userRepository: mockRepo)

        let user = User(id: 1, name: "John", surName: "Doe", email: "john@example.com")
        let resultId = viewModel.insertUser(user: user)

        #expect(resultId == 1)
        #expect(mockRepo.insertedUsers.count == 1)
        #expect(mockRepo.insertedUsers.first?.name == "John")
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testInsertUser_emptyName() async throws {
        let mockRepo = MockUserRepository()
        let viewModel = UserViewModel(userRepository: mockRepo)

        let user = User(id: 2, name: "   ", surName: "Doe", email: "john@example.com")
        let resultId = viewModel.insertUser(user: user)

        #expect(resultId == -1)
        #expect(viewModel.errorMessage != nil)
    }

    @Test
    func testInsertUser_invalidEmail() async throws {
        let mockRepo = MockUserRepository()
        let viewModel = UserViewModel(userRepository: mockRepo)

        let user = User(id: 3, name: "Jane", surName: "Doe", email: "")
        let resultId = viewModel.insertUser(user: user)

        #expect(resultId == -1)
        #expect(viewModel.errorMessage != nil)
    }

    @Test
    func testInsertUser_failure() async throws {
        let mockRepo = MockUserRepository()
        mockRepo.insertShouldReturnNil = true

        let viewModel = UserViewModel(userRepository: mockRepo)
        let user = User(id: 4, name: "Sam", surName: "Green", email: "sam@example.com")
        let resultId = viewModel.insertUser(user: user)

        #expect(resultId == -1)
        #expect(viewModel.errorMessage != nil)
    }

    @Test
    func testGetUsers_success() async throws {
        let mockRepo = MockUserRepository()
        mockRepo.fakeUsers = [
            User(id: 1, name: "Alice", surName: "Smith", email: "alice@example.com"),
            User(id: 2, name: "Bob", surName: "Jones", email: "bob@example.com")
        ]

        let viewModel = UserViewModel(userRepository: mockRepo)
        viewModel.getUsers()

        #expect(viewModel.users.count == 2)
        #expect(viewModel.name == "Alice")
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testGetUsers_empty() async throws {
        let mockRepo = MockUserRepository()
        mockRepo.fakeUsers = []

        let viewModel = UserViewModel(userRepository: mockRepo)
        viewModel.getUsers()

        #expect(viewModel.users.isEmpty)
        #expect(viewModel.errorMessage != nil)
    }

    @Test
    func testInitialCurrentUser() async throws {
        let mockRepo = MockUserRepository()
        let firstUser = User(id: 1, name: "Charlie", surName: "Brown", email: "charlie@example.com")
        mockRepo.fakeUsers = [firstUser]

        let viewModel = UserViewModel(userRepository: mockRepo)

        #expect(viewModel.currentUser?.name == "Charlie")
        #expect(viewModel.errorMessage == nil)
    }
}
