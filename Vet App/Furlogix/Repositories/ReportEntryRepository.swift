//
//  ReportEntryRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-08.
//

class ReportEntryRepository: ReportEntryRepositoryProtocol {
  func InsertEntries(entries: [ReportEntry]) -> Bool {
    AppLogger.debug("Inserting Report Entry")
    return ReportEntryStore.instance.InsertReportEntries(entries: entries)
  }

  func DeleteSentReportEntries() -> Bool {
    AppLogger.debug("Deleting Report Entry")
    return ReportEntryStore.instance.DeleteSentReportEntries()
  }

  func GetAllEntriesForReport(reportId: Int64) -> [ReportEntry]? {
    AppLogger.debug("Fetching all entries for report \(reportId)")
    return ReportEntryStore.instance.GetAllEntriesForReport(queryReportId: reportId)
  }

  func GetAllEntriesForReportTemplate(templateId: Int64) -> [ReportEntry]? {
    AppLogger.debug("Fetching all entries for report template \(templateId)")
    return ReportEntryStore.instance.GetAllEntriesForReportTemplate(queryTemplateId: templateId)
  }

  func UpdateReportEntry(entry: ReportEntry) -> Bool {
    AppLogger.debug("Updating report entry for entry: \(entry.id)")
    return ReportEntryStore.instance.UpdateReportEntries(entries: [entry])
  }

  func DeleteReportEntry(entryId: Int64) -> Bool {
    AppLogger.debug("Deleting report entry: \(entryId)")
    return ReportEntryStore.instance.DeleteReportEntry(entryId: entryId)
  }

}
