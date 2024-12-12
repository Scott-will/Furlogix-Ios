//
//  UserRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-10.
//
class UserRepository : UserRepositoryProtocol{
    
    func getUsers() -> [User] {
        return UsersStore.shared.getAllUsers()
    }
    
    func insertUsers(user: User) -> Int64? {
        return UsersStore.shared.insert(user: user)
    }
    
}
