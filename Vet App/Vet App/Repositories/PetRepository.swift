//
//  PetRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

class PetRepository : PetRepositoryProtocol{
    func GetPetsForUser(id: Int64) -> [Pet] {
        return PetStore.instance.GetPetsForUser(user_id: id)
    }
    
    func InsertPet(pet: Pet) -> Int64? {
        PetStore.instance.insert(pet: pet)
    }
}
