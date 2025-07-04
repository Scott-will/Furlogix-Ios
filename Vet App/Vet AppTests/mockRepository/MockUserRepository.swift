//
//  MockUserRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-04.
//
import Foundation
@testable import Vet_App

class MockUserRepository: UserRepositoryProtocol {
    var insertedUsers: [User] = []
    var fakeUsers: [User] = []

    func insertUsers(user: User) -> Int64? {
        insertedUsers.append(user)
        return 1
    }

    func getUsers() -> [User] {
        return fakeUsers
    }

    func getCurrentUser() -> User? {
        return fakeUsers.first
    }
}
