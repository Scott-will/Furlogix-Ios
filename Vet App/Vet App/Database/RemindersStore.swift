//
//  RemindersStore.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

import SQLite
import Foundation

class RemindersStore{
    
    static let DIR_USERS_DB = "Furlogix"
    static let STORE_NAME = "reminders.sqlite3"
    private var db: Connection? = nil
    private let pets = Table("reminders")

    private let id = SQLite.Expression<Int64>("id")
    private let frequency = SQLite.Expression<String>("frequency")
    private let type = SQLite.Expression<String>("type")
    private let startTime = SQLite.Expression<String>("startTime")
    private let title = SQLite.Expression<String>("title")
    private let Message = SQLite.Expression<String>("Message")
    
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
            try database.run(pets.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(frequency)
                table.column(type)
                table.column(startTime)
                table.column(title)
                table.column(Message)
            })
            print("Table Created...")
        } catch {
            print(error)
        }
    }
}
