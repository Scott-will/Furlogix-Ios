//
//  PetViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//
import Foundation

class PetViewModel : ObservableObject{
    @Published var pets : [Pet] = []
    @Published var currentpet : Pet?
    
    private let petRepository : PetRepositoryProtocol
    
    init(petRepository : PetRepositoryProtocol = DIContainer.shared.resolve(type: PetRepositoryProtocol.self)!){
        self.petRepository = petRepository
    }
    public func LoadPetsForUser(user_id : Int64){
        self.pets = self.petRepository.GetPetsForUser(id: user_id)
    }
    
    public func InsertPet(pet : Pet) -> Int64{
        let petId = self.petRepository.InsertPet(pet: pet)
        return petId ?? -1
    }
    
    public func UpdatePet(pet : Pet) -> Int64{
        let petId = self.petRepository.UpdatePet(pet: pet)
        return petId ?? -1
    }
    
    public func GetPetById(petId : Int64){
        self.currentpet = self.petRepository.GetPet(id: petId)
    }
    
    public func DeletePet(petId : Int64) -> Bool{
        return self.petRepository.DeletePet(id: petId)
    }
}
