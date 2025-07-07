//
//  AppDatabase.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-10.
//

import SQLite
import Foundation

class UsersStore{
    
    static let DIR_USERS_DB = "Furlogix"
    static let STORE_NAME = "users.sqlite3"
    private var db: Connection? = nil
    private let users = Table("users")

    private let id = SQLite.Expression<Int64>("id")
    private let name = SQLite.Expression<String>("name")
    private let surName = SQLite.Expression<String>("surName")
    private let petName = SQLite.Expression<String>("petName")
    private let email = SQLite.Expression<String>("email")

    static let instance = UsersStore()

    public func GetTable() -> Table{
        return users
    }
    
    public func GetPrimaryKeyColumn() -> SQLite.Expression<Int64>{
        return id;
    }

    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in:
                .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_USERS_DB)

            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
                db = try Connection(dbPath)
                try db?.run("PRAGMA foreign_keys = ON")
                createTable()
                print("SQLiteDataStore init successfully at: \(dbPath) ")
             } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
             }
         } else {
             db = nil
         }
     }

     private func createTable() {
         guard let database = db else {
             return
         }
         do {
             try database.run(users.create { table in
                 table.column(id, primaryKey: .autoincrement)
                 table.column(name)
                 table.column(surName)
                 table.column(email)
             })
             print("Table Created...")
         } catch {
             print(error)
         }
     }
    
    func insert(user : User) -> Int64? {
        guard let database = db else { return nil }

        let insert = users.insert(self.name <- user.name,
                                  self.surName <- user.surName,
                                  self.email <- user.email)
        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            print(error)
            return nil
        }
    }
    
    func getAllUsers() -> [User] {
        var usersList: [User] = []
        guard let database = db else { return [] }

        do {
            for user in try database.prepare(self.users) {
                usersList.append(User(id: user[id], name: user[name], surName: user[surName], email: user[email]))
            }
        } catch {
            print(error)
        }
        return usersList
    }
    
    func getCurrentUser() -> User?{
        guard let database = db else { return nil }
        
        do {
                if let row = try database.pluck(users) {
                    let userId = row[id]
                    let userName = row[name]
                    let surName = row[surName]
                    let email = row[email]
                    return User(id: userId, name: userName, surName: surName, email: email)
                } else {
                    return nil // No user found
                }
            }
        catch {
            print("Database error: \(error)")
            return nil
        }
    }
 }
