//
//  UserViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-09.
//
import Foundation

class UserViewModel: ObservableObject, ErrorMessageProvider {

  @Published var errorMessage: String? = nil
  //login stuff
  @Published var name: String = ""
  @Published var surName: String = ""
  @Published var email: String = ""
  @Published var petName: String = ""
  @Published var petType: String = ""

  //current user stuff

  @Published var currentUser: User?

  @Published var users: [User] = []
  private let userRepository: UserRepositoryProtocol

  init(
    userRepository: UserRepositoryProtocol = DIContainer.shared.resolve(
      type: UserRepositoryProtocol.self)!
  ) {
    self.userRepository = userRepository
    self.currentUser = userRepository.getCurrentUser()
  }

  public func insertUser(user: User) -> Int64 {
    if !IsValidUser(user: user) {
      AppLogger.error("Invalid user on insert: \(user.name)")
      return -1
    }
    AppLogger.debug("Inserting user with name: \(user.name)")
    let result = self.userRepository.insertUsers(user: user)
    self.getUsers()
    if result == nil {
      self.errorMessage = "Failed to insert user"
      return -1
    } else {
      self.errorMessage = nil
    }
    return result ?? -1
  }

  public func getUsers() {
    AppLogger.debug("Fetching all users")
    self.users = userRepository.getUsers()
    if self.users.isEmpty {
      AppLogger.error("Failed to fetch all users")
      self.errorMessage = "Failed to get users"
    } else {
      self.errorMessage = nil
    }
    self.name = users.first?.name ?? ""
    self.email = users.first?.email ?? ""
  }

  private func IsValidUser(user: User) -> Bool {
    if user.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      AppLogger.info("User has no first name")
      self.errorMessage = "Please provide a valid first name"
      return false
    }
    if user.surName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      AppLogger.info("User has no last name")
      self.errorMessage = "Please provide a valid last name"
      return false
    }
    if user.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      AppLogger.info("User has no email")
      self.errorMessage = "Please provide a valid email"
      return false
    }
    return true
  }
}
