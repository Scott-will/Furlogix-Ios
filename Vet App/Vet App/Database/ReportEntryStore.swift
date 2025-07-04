//
//  ReportEntryStore.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//


import SQLite
import Foundation

class ReportEntryStore{
    
    static let DIR_USERS_DB = "ReportEntryDB"
    static let STORE_NAME = "reportEntry.sqlite3"
    private var db: Connection? = nil
    private let reportEntrys = Table("reportEntrys")

    private let id = SQLite.Expression<Int64>("id")
    private let value = SQLite.Expression<String>("value")
    private let timestamp = SQLite.Expression<String>("timestamp")
    private let reportId = SQLite.Expression<Int64>("reportId")
    private let templateId = SQLite.Expression<Int64>("templateId")
    private let sent = SQLite.Expression<Bool>("sent")

    static let instance = ReportEntryStore()

     

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
            try database.run(reportEntrys.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(value)
                table.column(timestamp)
                table.column(reportId)
                table.column(templateId)
                table.foreignKey(reportId, references: ReportStore.instance.GetTable(), ReportStore.instance.GetPrimaryKeyColumn())
                table.foreignKey(templateId, references: ReportTemplateStore.instance.GetTable(), ReportTemplateStore.instance.GetPrimaryKeyColumn())
            })
            print("Table Created...")
        } catch {
            print(error)
        }
    }
    
    public func GetTable() -> Table{
        return reportEntrys
    }
    
    public func GetPrimaryKeyColumn() -> SQLite.Expression<Int64>{
        return id;
    }
}
