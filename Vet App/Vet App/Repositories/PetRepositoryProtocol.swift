//
//  PetRepositoryProtocol.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

protocol PetRepositoryProtocol{
    func GetPetsForUser(id : Int64) -> [Pet]
    
    func InsertPet(pet : Pet) -> Int64?
}
