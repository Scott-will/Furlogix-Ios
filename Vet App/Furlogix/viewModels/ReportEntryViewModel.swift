//
//  ReportEntryViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//

import SwiftUI

class ReportEntryViewModel: ObservableObject, ErrorMessageProvider {
  @Published var errorMessage: String? = nil

  private var reportEntryRepositoryProtocol: ReportEntryRepositoryProtocol

  @Published var reportEntryList: [ReportEntry] = []

  @Published var groupedEntries: [String: [ReportEntry]] = [:]

  init(
    reportEntryRepositoryProtocol: ReportEntryRepositoryProtocol = DIContainer.shared.resolve(
      type: ReportEntryRepositoryProtocol.self)!
  ) {
    self.reportEntryRepositoryProtocol = reportEntryRepositoryProtocol
  }

  func loadReportEntryList(reportId: Int64) {
    AppLogger.debug("Loading report entries for report: \(reportId)")
    let result = self.reportEntryRepositoryProtocol.GetAllEntriesForReport(reportId: reportId)
    if result == nil {
      self.errorMessage = "Failed to load entries for report: \(reportId)"
      AppLogger.error("Failed to load entries for report: \(reportId)")
      return
    }
    self.reportEntryList = result!
    self.loadGroupedEntries()
  }

  func insertReportEntry(entryValues: [Int64: String], reportId: Int64, timestamp: String) -> Bool {
    var entries: [ReportEntry] = []
    if timestamp.isEmpty {
      self.errorMessage = "Timestamp cannot be empty"
      return false
    }
    entryValues.forEach { item in
      let entry = ReportEntry(
        id: -1, value: item.value, reportId: reportId, templateId: item.key, timestamp: timestamp,
        sent: false)
      entries.append(entry)
    }

    let result = self.reportEntryRepositoryProtocol.InsertEntries(entries: entries)
    if result == false {
      AppLogger.error("Failed to insert report entries")
      self.errorMessage = "Failed to insert report entries for report \(reportId)"
      return false
    } else {
      self.errorMessage = nil
    }
    return true
  }

  private func loadGroupedEntries() {
    let groupedEntries = Dictionary(grouping: self.reportEntryList, by: { $0.timestamp })
    AppLogger.debug(String(groupedEntries.count))
    self.groupedEntries = groupedEntries
  }

}
