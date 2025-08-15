//
//  MockReportRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-08.
//

import Foundation

@testable import Furlogix

class MockReportRepository: ReportRepositoryProtocol {

  var fakeReports: [Report] = []
  var insertedReports: [Report] = []
  var updatedReports: [Report] = []
  var deletedReportIds: [Int64] = []
  var fetchedReportId: Int64?

  var insertShouldReturnNil = false
  var updateShouldReturnNil = false
  var deleteShouldReturnFalse = false
  var getShouldReturnFalse = false

  func getReportsForPet(petId: Int64) -> [Report] {
    if getShouldReturnFalse {
      return []
    }
    return fakeReports
  }

  func insertReport(report: Report) -> Int64? {
    if insertShouldReturnNil {
      return -1
    }
    insertedReports.append(report)
    return 1
  }

  func DeleteReport(reportId: Int64) -> Bool {
    if deleteShouldReturnFalse {
      return false
    }
    deletedReportIds.append(reportId)
    return true
  }

  func UpdateReport(report: Report) -> Int64? {
    if updateShouldReturnNil {
      return -1
    }
    updatedReports.append(report)
    return 1
  }

  func GetReportById(reportId: Int64) -> Report? {
    if getShouldReturnFalse {
      return nil
    }
    fetchedReportId = reportId
    return fakeReports.first { $0.id == reportId }
  }

}
