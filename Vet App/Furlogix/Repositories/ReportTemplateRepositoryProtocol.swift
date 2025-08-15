//
//  ReportTemplateRepositoryProtocol.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//

protocol ReportTemplateRepositoryProtocol {
  func GetTemplatesForReport(reportId: Int64) -> [ReportTemplateField]

  func GetTemplateById(templateId: Int64) -> ReportTemplateField?

  func InsertReportTemplate(template: ReportTemplateField) -> Int64?

  func UpdateReportTemplate(template: ReportTemplateField) -> Int64?

  func DeleteReportTemplate(templateId: Int64) -> Bool
}
