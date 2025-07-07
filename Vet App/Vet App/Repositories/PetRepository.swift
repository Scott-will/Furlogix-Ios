//
//  PetRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

class PetRepository : PetRepositoryProtocol{
    func GetPet(id: Int64) -> Pet? {
        return PetStore.instance.GetPetById(petId: id)
    }
    
    func GetPetsForUser(id: Int64) -> [Pet] {
        return PetStore.instance.GetPetsForUser(user_id: id)
    }
    
    func InsertPet(pet: Pet) -> Int64? {
        PetStore.instance.insert(pet: pet)
    }
    
    func DeletePet(id: Int64) -> Bool {
        return PetStore.instance.delete(petId: id)
    }
    
    func UpdatePet(pet: Pet) -> Int64? {
        return PetStore.instance.update(pet: pet)
    }
}
