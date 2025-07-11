//
//  ReportTemplateStore.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//


import SQLite
import Foundation

class ReportTemplateStore{
    static let DIR_USERS_DB = "Furlogix"
    static let STORE_NAME = "reportTemplates.sqlite3"
    private var db: Connection? = nil
    private let reportTemplates = Table("reportTemplates")

    private let id = SQLite.Expression<Int64>("id")
    private let name = SQLite.Expression<String>("name")
    private let reportId = SQLite.Expression<Int64>("reportId")
    private let fieldType = SQLite.Expression<Int64>("fieldType")

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
                table.foreignKey(reportId, references: ReportStore.instance.GetTable(), ReportStore.instance.GetPrimaryKeyColumn())
            })
            print("Table Created...")
        } catch {
            AppLogger.error("\(error)")
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
                templateList.append(ReportTemplateField(id: reportTemplate[id], reportId: reportTemplate[reportId], name: reportTemplate[name], fieldType: FieldType(rawValue: Int(reportTemplate[fieldType])) ?? FieldType.Text))
            }
        }
        catch {
            AppLogger.error("\(error)")
        }
        return templateList
    }
    
    public func GetReportTemplateById(templateId : Int64) -> ReportTemplateField? {
        guard let database = db else {return nil }
        do{
            for template in try database.prepare(self.reportTemplates.filter(id == templateId)){
                return ReportTemplateField(
                    id: Int64(template[id]),
                    reportId: Int64(template[reportId]),
                    name: template[name],
                    fieldType: FieldType(rawValue: Int(template[fieldType])) ?? FieldType.Text
                )
            }
        }
        catch{
            AppLogger.error("\(error)")
        }
        return nil
    }
    
    public func InsertReportTemplate(template : ReportTemplateField) -> Int64? {
        guard let database = db else { return nil }

        let insert = reportTemplates.insert(
            self.name <- template.name,
            self.reportId <- template.reportId,
            self.fieldType <- Int64(template.fieldType.rawValue))
        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            AppLogger.error("\(error)")
            return nil
        }
    }
    
    public func UpdateReportTemplate(template: ReportTemplateField) -> Int64? {
        guard let database = db else { return nil }

        let templateToUpdate = reportTemplates.filter(self.id == template.id)

        let update = templateToUpdate.update(
            self.name <- template.name,
            self.reportId <- template.reportId,
            self.fieldType <- Int64(template.fieldType.rawValue),
        )

        do {
            let rowsAffected = try database.run(update)
            return Int64(rowsAffected)
        } catch {
            AppLogger.error("\(error)")
            return nil
        }
    }
    
    public func DeleteReportTemplate(templateId: Int64) -> Bool {
        guard let database = db else { return false }

        let templateToDelete = reportTemplates.filter(self.id == templateId)

        do {
            try database.run(templateToDelete.delete())
            return true
        } catch {
            AppLogger.error("\(error)")
            return false
        }
    }
}
