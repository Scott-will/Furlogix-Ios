//
//  UserRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-10.
//
class UserRepository : UserRepositoryProtocol{
    
    func getUsers() -> [User] {
        return [User(id: 1, name: "String", surName: "String", petName: "String", email: "String")]
    }
    
    func insertUsers(user: User) -> Int {
        return 1
    }
    
}
