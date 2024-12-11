//
//  AppDatabase.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-10.
//

import SQLite

class UsersStore{
    
    static let DIR_USERS_DB = "UsersDB"
    static let STORE_NAME = "users.sqlite3"
    private var db: Connection? = nil
    private let tasks = Table("users")

    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let surName = Expression<String>("surName")
    private let petName = Expression<String>("petName")
    private let email = Expression<String>("email")

    static let shared = UsersStore()

     

    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in:
                .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_USERS_DB)

            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
                db = try Connection(dbPath)
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
             try database.run(tasks.create { table in
                 table.column(id, primaryKey: .autoincrement)
                 table.column(name)
                 table.column(surName)
                 table.column(email)
                 table.column(petName)
             })
             print("Table Created...")
         } catch {
             print(error)
         }
     }
 }
