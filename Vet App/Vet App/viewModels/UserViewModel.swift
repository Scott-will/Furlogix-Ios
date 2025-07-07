//
//  UserViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-09.
//
import Foundation

class UserViewModel : ObservableObject{
    //login stuff
    @Published var name: String = ""
    @Published var surName: String = ""
    @Published var email: String = ""
    @Published var petName: String = ""
    @Published var petType: String = ""
    
    //current user stuff
    
    @Published var currentUser : User?
    
    @Published var users : [User] = []
    private let userRepository : UserRepositoryProtocol
    
    init(userRepository : UserRepositoryProtocol = DIContainer.shared.resolve(type: UserRepositoryProtocol.self)!){
        self.userRepository = userRepository
        self.currentUser = userRepository.getCurrentUser()
    }
    
    public func insertUser(user : User) -> Int64{
        let result = self.userRepository.insertUsers(user: user)
        self.getUsers()
        return result ?? -1
    }
    
    public func getUsers(){
        self.users = userRepository.getUsers()
        self.name = users.first?.name ?? ""
    }
}
