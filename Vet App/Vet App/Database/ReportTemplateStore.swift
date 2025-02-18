//
//  ReportTemplateStore.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//


import SQLite
import Foundation

class ReportTemplateStore{
    static let DIR_USERS_DB = "ReportsDb"
    static let STORE_NAME = "reportTemplates.sqlite3"
    private var db: Connection? = nil
    private let reportTemplates = Table("reportTemplates")

    private let id = SQLite.Expression<Int64>("id")
    private let name = SQLite.Expression<String>("name")
    private let reportId = SQLite.Expression<Int64>("reportId")
    private let fieldType = SQLite.Expression<Int64>("fieldType")
    private let favourite = SQLite.Expression<Bool>("favourite")

    static let instance = ReportTemplateStore()

     

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
            try database.run(reportTemplates.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(name)
                table.column(reportId)
                table.column(fieldType)
                table.column(favourite)
                table.foreignKey(reportId, references: ReportStore.instance.GetTable(), ReportStore.instance.GetPrimaryKeyColumn())
            })
            print("Table Created...")
        } catch {
            print(error)
        }
    }
    
    public func GetTable() -> Table{
        return reportTemplates
    }
    
    public func GetPrimaryKeyColumn() -> SQLite.Expression<Int64>{
        return id;
    }
    
    public func GetReportTemplatesForReport(report_id : Int64) -> [ReportTemplateField]{
        var templateList : [ReportTemplateField] = []
        guard let database = db else {return []}
        do {
            for reportTemplate in try database.prepare(self.reportTemplates.filter(reportId == report_id)){
                templateList.append(ReportTemplateField(id: reportTemplate[id], reportId: reportTemplate[reportId], name: reportTemplate[name], favourite: reportTemplate[favourite], fieldType: FieldType(rawValue: Int(reportTemplate[fieldType])) ?? FieldType.Text))
            }
        }
        catch {
            print(error)
        }
        return templateList
    }
    
    public func InsertReportTemplate(template : ReportTemplateField) -> Int64? {
        guard let database = db else { return nil }

        let insert = reportTemplates.insert(
            self.name <- template.name,
            self.reportId <- template.reportId,
            self.fieldType <- Int64(template.fieldType.rawValue),
            self.favourite <- template.favourite)
        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            print(error)
            return nil
        }
    }
    
}
