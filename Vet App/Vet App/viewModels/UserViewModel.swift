//
//  UserViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-09.
//
import Foundation

class UserViewModel : ObservableObject{
    @Published var name: String = ""
    @Published var surName: String = ""
    @Published var email: String = ""
    @Published var petName: String = ""
    @Published var petType: String = ""
    
    @Published var users : [User] = []
    private let userRepository : UserRepositoryProtocol
    
    init(userRepository : UserRepositoryProtocol = DIContainer.shared.resolve(type: UserRepositoryProtocol.self)!){
        self.userRepository = userRepository
    }
    
    public func insertUser(user : User) -> Int64{
        let result = self.userRepository.insertUsers(user: user)
        return result ?? -1
    }
    
    public func getUsers(){
        self.users = userRepository.getUsers()
        self.name = users.first?.name ?? ""
    }
}
