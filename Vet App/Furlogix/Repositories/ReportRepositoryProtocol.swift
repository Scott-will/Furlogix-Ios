//
//  ReportRepositoryProtocol.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//

protocol ReportRepositoryProtocol {
  func getReportsForPet(petId: Int64) -> [Report]

  func insertReport(report: Report) -> Int64?

  func DeleteReport(reportId: Int64) -> Bool

  func UpdateReport(report: Report) -> Int64?

  func GetReportById(reportId: Int64) -> Report?
}
