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
    
    var insertShouldReturnNil = false
    var updateShouldReturnNil = false
    var deleteShouldReturnFalse = false

    func insertUsers(user: User) -> Int64? {
        if(insertShouldReturnNil){
            return nil
        }
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
