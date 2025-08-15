//
//  MockReportEntryRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-09.
//
import Foundation

@testable import Furlogix

class MockReportEntryRepository: ReportEntryRepositoryProtocol {
  var shouldReturnNilOnGet = false
  var shouldFailInsert = false
  var fakeEntries: [ReportEntry] = []

  func DeleteSentReportEntries() -> Bool {
    return true
  }

  func GetAllEntriesForReportTemplate(templateId: Int64) -> [ReportEntry]? {
    return nil
  }

  func UpdateReportEntry(entry: ReportEntry) -> Bool {
    return true
  }

  func DeleteReportEntry(entryId: Int64) -> Bool {
    return true
  }

  func GetAllEntriesForReport(reportId: Int64) -> [ReportEntry]? {
    if shouldReturnNilOnGet {
      return nil
    }
    return fakeEntries
  }

  func InsertEntries(entries: [ReportEntry]) -> Bool {
    if shouldFailInsert {
      return false
    }
    fakeEntries.append(contentsOf: entries)
    return true
  }
}
