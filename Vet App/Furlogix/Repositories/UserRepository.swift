//
//  UserRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-10.
//
class UserRepository: UserRepositoryProtocol {

  func getUsers() -> [User] {
    AppLogger.debug("fetching all users")
    return UsersStore.instance.getAllUsers()
  }

  func insertUsers(user: User) -> Int64? {
    AppLogger.debug("Inserting User \(user.name)")
    return UsersStore.instance.insert(user: user)
  }

  func getCurrentUser() -> User? {
    AppLogger.debug("fetching current user")
    return UsersStore.instance.getAllUsers().first
  }

}
