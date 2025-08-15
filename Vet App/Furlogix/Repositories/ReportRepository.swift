//
//  ReportRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//

class ReportRepository: ReportRepositoryProtocol {
  func DeleteReport(reportId: Int64) -> Bool {
    AppLogger.debug("Deleting report: \(reportId)")
    return ReportStore.instance.delete(reportId: reportId)
  }

  func UpdateReport(report: Report) -> Int64? {
    AppLogger.debug("Upadting report: \(report.id)")
    return ReportStore.instance.update(report: report)
  }

  func GetReportById(reportId: Int64) -> Report? {
    AppLogger.debug("fetching report: \(reportId)")
    return ReportStore.instance.getReportById(reportId: reportId)
  }

  public func getReportsForPet(petId: Int64) -> [Report] {
    AppLogger.debug("Fetching reports for pet: \(petId)")
    return ReportStore.instance.GetReportsForPet(pet_id: petId)

  }

  public func insertReport(report: Report) -> Int64? {
    AppLogger.debug("Inserting report: \(report.name)")
    return ReportStore.instance.insert(report: report)
  }
}
