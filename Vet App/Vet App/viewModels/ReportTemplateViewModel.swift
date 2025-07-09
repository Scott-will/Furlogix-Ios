//
//  ReportTemplateViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//

import Foundation

class ReportTemplateViewModel : ObservableObject, ErrorMessageProvider{
    @Published var errorMessage: String? = nil

    @Published var templatesForReports : [ReportTemplateField] = []
    
    private let reportTemplateRepository : ReportTemplateRepositoryProtocol
    
    init( reportTemplateRepository : ReportTemplateRepositoryProtocol = DIContainer.shared.resolve(type: ReportTemplateRepositoryProtocol.self)!){
        self.reportTemplateRepository = reportTemplateRepository
    }
    
    public func GetReportTemplateForReport(reportId : Int64){
        self.templatesForReports = reportTemplateRepository.GetTemplatesForReport(reportId: reportId)
    }
    
    public func InsertReportTemplate(template : ReportTemplateField) -> Int64?{
        return reportTemplateRepository.InsertReportTemplate(template: template)
    }
    
    public func DeleteReportTemplate(templateId : Int64){
        reportTemplateRepository.DeleteReportTemplate(templateId: templateId)
    }
    
    public func UpdateReportTemplate(template : ReportTemplateField){
        reportTemplateRepository.UpdateReportTemplate(template: template)
    }
}
