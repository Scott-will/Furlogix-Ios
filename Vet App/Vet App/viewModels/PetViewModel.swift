//
//  PetViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//
import Foundation

class PetViewModel : ObservableObject, ErrorMessageProvider{
    @Published var pets : [Pet] = []
    @Published var currentpet : Pet?
    @Published var errorMessage : String? = nil

    private let petRepository : PetRepositoryProtocol
    
    init(petRepository : PetRepositoryProtocol = DIContainer.shared.resolve(type: PetRepositoryProtocol.self)!){
        self.petRepository = petRepository
    }
    public func LoadPetsForUser(user_id : Int64){
        self.pets = self.petRepository.GetPetsForUser(id: user_id)
        if(self.pets.isEmpty){
            self.errorMessage = "No Pets Found"
        }
        else{
            self.errorMessage = nil
        }
    }
    
    public func InsertPet(pet : Pet) -> Int64{
        if(!IsValidPet(pet: pet)){
            return -1
        }
        let petId = self.petRepository.InsertPet(pet: pet)
        if(petId == nil){
            self.errorMessage = "Failed to Insert Pet"
            return -1
        }
        else{
            self.errorMessage = nil
        }
        return petId ?? -1
    }
    
    public func UpdatePet(pet : Pet) -> Int64{
        if(!IsValidPet(pet: pet)){
            return -1
        }
        let petId = self.petRepository.UpdatePet(pet: pet)
        if(petId == nil){
            self.errorMessage = "Failed to Update Pet"
            return -1
        }
        else{
            self.errorMessage = nil
        }
        return petId ?? -1
    }
    
    public func GetPetById(petId : Int64){
        self.currentpet = self.petRepository.GetPet(id: petId)
        if(self.currentpet ==  nil){
            self.errorMessage = "No Pet Found"
        }
        else{
            self.errorMessage = nil
        }
    }
    
    public func DeletePet(petId : Int64) -> Bool{
        let result = self.petRepository.DeletePet(id: petId)
        if(result == false){
            self.errorMessage = "Failed to Delete Pet"
        }
        else{
            self.errorMessage = nil
        }
        return result
    }
    
    private func IsValidPet(pet : Pet) -> Bool{
        if(pet.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            self.errorMessage = "Please provide a proper name"
            return false
        }
        return true
    }
}
