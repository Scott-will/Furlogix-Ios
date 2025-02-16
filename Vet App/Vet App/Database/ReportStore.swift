//
//  ReportStore.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

import SQLite
import Foundation

class ReportStore{
    static let DIR_USERS_DB = "ReportsDb"
    static let STORE_NAME = "reports.sqlite3"
    private var db: Connection? = nil
    private let reports = Table("reports")

    private let id = SQLite.Expression<Int64>("id")
    private let name = SQLite.Expression<String>("name")
    private let petId = SQLite.Expression<Int64>("petId")

    static let instance = ReportStore()

     

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
            try database.run(reports.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(name)
                table.column(petId)
                table.foreignKey(petId, references: PetStore.instance.GetTable(), PetStore.instance.GetPrimaryKeyColumn())
            })
            print("Table Created...")
        } catch {
            print(error)
        }
    }
    
    public func GetTable() -> Table{
        return reports
    }
    
    public func GetPrimaryKeyColumn() -> SQLite.Expression<Int64>{
        return id;
    }
}
