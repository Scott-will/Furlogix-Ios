//
//  ReportEntryStore.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

import Foundation
import SQLite

class ReportEntryStore {

  static let DIR_USERS_DB = "Furlogix"
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
    if let docDir = FileManager.default.urls(
      for: .documentDirectory,
      in:
        .userDomainMask
    ).first {
      let dirPath = docDir.appendingPathComponent(Self.DIR_USERS_DB)

      do {
        try FileManager.default.createDirectory(
          atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
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
      try database.run(
        reportEntrys.create { table in
          table.column(id, primaryKey: .autoincrement)
          table.column(value)
          table.column(timestamp)
          table.column(reportId)
          table.column(templateId)
          table.column(sent)
          table.foreignKey(
            reportId, references: ReportStore.instance.GetTable(),
            ReportStore.instance.GetPrimaryKeyColumn())
          table.foreignKey(
            templateId, references: ReportTemplateStore.instance.GetTable(),
            ReportTemplateStore.instance.GetPrimaryKeyColumn())
        })
      print("Table Created...")
    } catch {
      AppLogger.error("\(error)")
    }
  }

  public func GetTable() -> Table {
    return reportEntrys
  }

  public func GetPrimaryKeyColumn() -> SQLite.Expression<Int64> {
    return id
  }

  public func GetAllEntriesForReport(queryReportId: Int64) -> [ReportEntry]? {
    var entries = [ReportEntry]()
    guard let database = db else {
      return nil
    }
    do {
      for entry in try database.prepare(self.reportEntrys.filter(reportId == queryReportId)) {
        entries.append(
          ReportEntry(
            id: Int64(entry[id]),
            value: String(entry[value]),
            reportId: Int64(entry[reportId]),
            templateId: Int64(entry[templateId]),
            timestamp: String(entry[timestamp]),
            sent: Bool(entry[sent])))
      }
    } catch {
      AppLogger.error("\(error)")
      return nil
    }
    return entries
  }

  public func GetAllEntriesForReportTemplate(queryTemplateId: Int64) -> [ReportEntry]? {
    var entries = [ReportEntry]()
    guard let database = db else {
      return nil
    }
    do {
      for entry in try database.prepare(self.reportEntrys.filter(templateId == queryTemplateId)) {
        entries.append(
          ReportEntry(
            id: Int64(entry[id]),
            value: String(entry[value]),
            reportId: Int64(entry[reportId]),
            templateId: Int64(entry[templateId]),
            timestamp: String(entry[timestamp]),
            sent: Bool(entry[sent])))
      }
    } catch {
      AppLogger.error("\(error)")
      return nil
    }
    return entries
  }

  public func InsertReportEntries(entries: [ReportEntry]) -> Bool {
    guard let database = db else { return false }
    do {
      for entry in entries {
        let insert = reportEntrys.insert(
          value <- entry.value,
          reportId <- entry.reportId,
          templateId <- entry.templateId,
          timestamp <- entry.timestamp,
          sent <- entry.sent
        )
        try database.run(insert)
      }
    } catch {
      AppLogger.error("\(error)")
      return false
    }
    return true
  }

  public func DeleteSentReportEntries() -> Bool {
    guard let database = db else { return false }
    let entriesToDelete = reportEntrys.filter(sent == true)
    do {
      try database.run(entriesToDelete.delete())
      return true
    } catch {
      AppLogger.error("\(error)")
      return false
    }
  }

  public func DeleteReportEntry(entryId: Int64) -> Bool {
    guard let database = db else { return false }
    let entriesToDelete = reportEntrys.filter(id == entryId)
    do {
      try database.run(entriesToDelete.delete())
      return true
    } catch {
      AppLogger.error("\(error)")
      return false
    }
  }

  public func UpdateReportEntries(entries: [ReportEntry]) -> Bool {
    guard let database = db else { return false }
    do {
      for entry in entries {
        let entryToUpdate = reportEntrys.filter(id == entry.id)
        let update = entryToUpdate.update(
          value <- entry.value,
          reportId <- entry.reportId,
          templateId <- entry.templateId,
          timestamp <- entry.timestamp,
          sent <- entry.sent
        )

        try database.run(update)
      }
    } catch {
      AppLogger.error("\(error)")
      return false
    }
    return true

  }

}
