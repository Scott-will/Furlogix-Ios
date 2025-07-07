//
//  ReportTemplateRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//

class ReportTemplateRepository : ReportTemplateRepositoryProtocol{
    func GetTemplateById(templateId: Int64) -> ReportTemplateField? {
        return ReportTemplateStore.instance.GetReportTemplateById(templateId: templateId)
    }
    
    func UpdateReportTemplate(template: ReportTemplateField) -> Int64? {
        return ReportTemplateStore.instance.UpdateReportTemplate(template: template)
    }
    
    func DeleteReportTemplate(templateId: Int64) -> Bool {
        return ReportTemplateStore.instance.DeleteReportTemplate(templateId: templateId)
    }
    
    public func GetTemplatesForReport(reportId: Int64) -> [ReportTemplateField] {
        return ReportTemplateStore.instance.GetReportTemplatesForReport(report_id: reportId)
    }
    
    public func InsertReportTemplate(template: ReportTemplateField) -> Int64? {
        return ReportTemplateStore.instance.InsertReportTemplate(template: template)
    }
}
