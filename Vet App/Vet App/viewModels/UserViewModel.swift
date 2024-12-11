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
    
    @Published var users : [User] = []
    private let userRepository : UserRepositoryProtocol
    
    init(userRepository : UserRepositoryProtocol = DIContainer.shared.resolve(type: UserRepositoryProtocol.self)!){
        self.userRepository = userRepository
    }
    
    public func insertUser(){
        var result = self.userRepository.insertUsers(user: User(id: 1, name: "test", surName: "test", petName: "", email: ""))
        if(result == -1){
            //log here
        }
    }
    
    public func getUsers(){
        self.users = userRepository.getUsers()
        self.name = users.first?.name ?? ""
    }
}
