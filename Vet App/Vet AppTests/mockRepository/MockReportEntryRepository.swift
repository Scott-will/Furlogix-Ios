//
//  MockReportEntryRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-09.
//
import Foundation
@testable import Vet_App

class MockReportEntryRepository: ReportEntryRepositoryProtocol {
    var shouldReturnNilOnGet = false
    var shouldFailInsert = false
    var fakeEntries: [ReportEntry] = []
    
    var deleteSentReportEntriesAsyncCalled = false
    var deleteSentReportEntriesSyncCalled = false
    var deleteshouldSucceed = true
    var deleteshouldDelay = false
    var errorToThrow: Error?
    
    func deleteSentReportEntries() throws {
        deleteSentReportEntriesSyncCalled = true
        
        if deleteshouldDelay {
            Thread.sleep(forTimeInterval: 2.0)
        }
        
        if !deleteshouldSucceed {
            throw errorToThrow ?? ReportCleanupError.databaseError
        }
    }
    
    func deleteSentReportEntries() async throws {
        deleteSentReportEntriesAsyncCalled = true
        
        if deleteshouldDelay {
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        }
        
        if !deleteshouldSucceed {
            throw errorToThrow ?? ReportCleanupError.databaseError
        }
    }
    
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


