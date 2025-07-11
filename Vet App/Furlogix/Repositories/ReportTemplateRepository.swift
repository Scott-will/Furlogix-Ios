//
//  ReportTemplateRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//

class ReportTemplateRepository : ReportTemplateRepositoryProtocol{
    func GetTemplateById(templateId: Int64) -> ReportTemplateField? {
        AppLogger.debug("Fetching report template: \(templateId)")
        return ReportTemplateStore.instance.GetReportTemplateById(templateId: templateId)
    }
    
    func UpdateReportTemplate(template: ReportTemplateField) -> Int64? {
        AppLogger.debug("Updating report template: \(template.name)")
        return ReportTemplateStore.instance.UpdateReportTemplate(template: template)
    }
    
    func DeleteReportTemplate(templateId: Int64) -> Bool {
        AppLogger.debug("Deleting report template: \(templateId)")
        return ReportTemplateStore.instance.DeleteReportTemplate(templateId: templateId)
    }
    
    public func GetTemplatesForReport(reportId: Int64) -> [ReportTemplateField] {
        AppLogger.debug("Fetching report template for report: \(reportId)")
        return ReportTemplateStore.instance.GetReportTemplatesForReport(report_id: reportId)
    }
    
    public func InsertReportTemplate(template: ReportTemplateField) -> Int64? {
        AppLogger.debug("Inserting report template: \(template.name) for report \(template.reportId)")
        return ReportTemplateStore.instance.InsertReportTemplate(template: template)
    }
}
