//
//  RemindersStore.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

import Foundation
import SQLite

class RemindersStore {

  static let DIR_USERS_DB = "Furlogix"
  static let STORE_NAME = "reminders.sqlite3"
  private var db: Connection? = nil
  private let reminders = Table("reminders")

  private let id = SQLite.Expression<Int64>("id")
  private let frequency = SQLite.Expression<String>("frequency")
  private let startTime = SQLite.Expression<String>("startTime")
  private let title = SQLite.Expression<String>("title")
  private let message = SQLite.Expression<String>("Message")
  private let requestId = SQLite.Expression<String>("requestId")

  static let instance = RemindersStore()

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
        reminders.create { table in
          table.column(id, primaryKey: .autoincrement)
          table.column(frequency)
          table.column(startTime)
          table.column(title)
          table.column(message)
          table.column(requestId)
        })
      print("Table Created...")
    } catch {
      AppLogger.error("\(error)")
    }
  }

  func getAllReminders() -> [Reminder]? {
    var allReminders: [Reminder] = []
    guard let database = db else {
      return nil
    }
    do {
      for reminder in try database.prepare(reminders) {
        allReminders.append(
          Reminder(
            id: Int64(reminder[id]),
            frequency: String(reminder[frequency]),
            startTime: String(reminder[startTime]),
            title: String(reminder[title]),
            message: String(reminder[message]),
            requestId: String(reminder[requestId])
          ))
      }
    } catch {
      AppLogger.error("\(error)")
      return nil
    }
    return allReminders
  }

  func deleteReminder(reminderId: Int64) {
    guard let database = db else {
      return
    }
    do {
      try database.run(reminders.filter(id == reminderId).delete())
    } catch {
      AppLogger.error("\(error)")
    }
  }

  func insertReminder(reminder: Reminder) -> Int64? {
    guard let database = db else {
      return nil
    }
    do {
      let rowID = try database.run(
        reminders.insert(
          frequency <- reminder.frequency,
          startTime <- reminder.startTime,
          title <- reminder.title,
          message <- reminder.message,
          requestId <- reminder.requestId
        ))
      return rowID
    } catch {
      AppLogger.error("\(error)")
      return nil
    }
  }
}
