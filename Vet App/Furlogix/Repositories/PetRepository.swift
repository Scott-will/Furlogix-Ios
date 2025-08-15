//
//  PetRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

class PetRepository: PetRepositoryProtocol {
  func GetPet(id: Int64) -> Pet? {
    AppLogger.debug("Fethcing pet with id \(id)")
    return PetStore.instance.GetPetById(petId: id)
  }

  func GetPetsForUser(id: Int64) -> [Pet] {
    AppLogger.debug("Fethcing pets for user with id \(id)")
    return PetStore.instance.GetPetsForUser(user_id: id)
  }

  func InsertPet(pet: Pet) -> Int64? {
    AppLogger.debug("Inserting pet: \(pet.name)")
    return PetStore.instance.insert(pet: pet)
  }

  func DeletePet(id: Int64) -> Bool {
    AppLogger.debug("Deleting pet with id: \(id)")
    return PetStore.instance.delete(petId: id)
  }

  func UpdatePet(pet: Pet) -> Int64? {
    AppLogger.debug("Updating pet: \(pet.name)")
    return PetStore.instance.update(pet: pet)
  }
}
