//
//  UserRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-10.
//
class UserRepository : UserRepositoryProtocol{
    
    func getUsers() -> [User] {
        return UsersStore.instance.getAllUsers()
    }
    
    func insertUsers(user: User) -> Int64? {
        return UsersStore.instance.insert(user: user)
    }
    
    func getCurrentUser() -> User? {
        return UsersStore.instance.getAllUsers().first
    }
    
}
