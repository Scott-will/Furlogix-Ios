//
//  ReportStore.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

import Foundation
import SQLite

class ReportStore {
  static let DIR_USERS_DB = "Furlogix"
  static let STORE_NAME = "reports.sqlite3"
  private var db: Connection? = nil
  private let reports = Table("reports")

  private let id = SQLite.Expression<Int64>("id")
  private let name = SQLite.Expression<String>("name")
  private let petId = SQLite.Expression<Int64>("petId")

  static let instance = ReportStore()

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
        reports.create { table in
          table.column(id, primaryKey: .autoincrement)
          table.column(name)
          table.column(petId)
          table.foreignKey(
            petId, references: PetStore.instance.GetTable(), PetStore.instance.GetPrimaryKeyColumn()
          )
        })
      print("Table Created...")
    } catch {
      AppLogger.error("\(error)")
    }
  }

  public func GetTable() -> Table {
    return reports
  }

  public func GetPrimaryKeyColumn() -> SQLite.Expression<Int64> {
    return id
  }

  public func GetReportsForPet(pet_id: Int64) -> [Report] {
    var reportList: [Report] = []
    guard let database = db else { return [] }
    do {
      for report in try database.prepare(self.reports.filter(petId == pet_id)) {
        reportList.append(
          Report(
            id: report[id],
            name: report[name],
            petId: report[petId]))
      }
    } catch {
      AppLogger.error("\(error)")
    }
    return reportList
  }

  func insert(report: Report) -> Int64? {
    guard let database = db else { return nil }

    let insert = reports.insert(
      self.name <- report.name,
      self.petId <- report.petId)
    do {
      let rowID = try database.run(insert)
      return rowID
    } catch {
      AppLogger.error("\(error)")
      return nil
    }
  }

  func getReportById(reportId: Int64) -> Report? {
    guard let database = db else { return nil }

    let query = reports.filter(self.id == reportId)

    do {
      if let row = try database.pluck(query) {
        return Report(
          id: row[self.id],
          name: row[self.name],
          petId: row[self.petId]
        )
      }
    } catch {
      AppLogger.error("\(error)")
    }
    return nil
  }

  func update(report: Report) -> Int64? {
    guard let database = db else { return nil }

    let reportToUpdate = reports.filter(self.id == report.id)

    let update = reportToUpdate.update(
      self.name <- report.name,
      self.petId <- report.petId
    )

    do {
      let rowsAffected = try database.run(update)
      return Int64(rowsAffected)
    } catch {
      AppLogger.error("\(error)")
      return nil
    }
  }

  func delete(reportId: Int64) -> Bool {
    guard let database = db else { return false }

    let reportToDelete = reports.filter(self.id == reportId)

    do {
      try database.run(reportToDelete.delete())
      return true
    } catch {
      AppLogger.error("\(error)")
      return false
    }
  }

}
