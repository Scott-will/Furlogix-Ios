//
//  PetRepositoryProtocol.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

protocol PetRepositoryProtocol{
    func GetPetsForUser(id : Int64) -> [Pet]
    
    func InsertPet(pet : Pet) -> Int64?
    
    func DeletePet(id : Int64) -> Bool
    
    func UpdatePet(pet : Pet) -> Int64?
    
    func GetPet(id : Int64) -> Pet?
}
