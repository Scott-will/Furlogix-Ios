//
//  UserRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-10.
//
protocol UserRepositoryProtocol{
    func getUsers() -> [User]
    
    func insertUsers(user : User) -> Int
}
