//
//  ReportEntryRepositoryProtocol.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

protocol ReportEntryRepositoryProtocol{
    func InsertEntries(entries: [ReportEntry]) -> Bool
    
    func DeleteSentReportEntries() -> Bool
    
    func GetAllEntriesForReport(reportId : Int64) -> [ReportEntry]?
    
    func GetAllEntriesForReportTemplate(templateId : Int64) -> [ReportEntry]?
    
    func UpdateReportEntry(entry: ReportEntry) -> Int64?
    
    func DeleteReportEntry(entryId: Int64) -> Bool
}
