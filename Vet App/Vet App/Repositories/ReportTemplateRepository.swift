//
//  ReportTemplateRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//

class ReportTemplateRepository : ReportTemplateRepositoryProtocol{
    
    public func GetTemplatesForReport(reportId: Int64) -> [ReportTemplateField] {
        return ReportTemplateStore.instance.GetReportTemplatesForReport(report_id: reportId)
    }
    
    public func InsertReportTemplate(template: ReportTemplateField) -> Int64? {
        return ReportTemplateStore.instance.InsertReportTemplate(template: template)
    }
}
