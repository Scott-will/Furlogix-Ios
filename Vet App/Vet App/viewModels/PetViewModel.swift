//
//  PetViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//
import Foundation

class PetViewModel : ObservableObject{
    @Published var pets : [Pet] = []
    
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
}
