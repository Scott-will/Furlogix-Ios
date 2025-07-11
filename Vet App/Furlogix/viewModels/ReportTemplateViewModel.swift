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
        if(self.templatesForReports.isEmpty){
            self.errorMessage = "Failed to get templates for report : \(reportId)"
        }
    }
    
    public func InsertReportTemplate(template : ReportTemplateField) -> Int64?{
        if(!self.IsValidReportTemplate(template: template)){
            return -1
        }
        let result = reportTemplateRepository.InsertReportTemplate(template: template)
        if(result == -1){
            self.errorMessage = "Unable to insert report template."
        }
        else{
            self.errorMessage = nil
        }
        return result
    }
    
    public func DeleteReportTemplate(templateId : Int64) -> Bool{
        let result = reportTemplateRepository.DeleteReportTemplate(templateId: templateId)
        if(!result){
            self.errorMessage = "Unable to delete report template."
            return false
        }
        else{
            self.errorMessage = nil
        }
        return true
    }
    
    public func UpdateReportTemplate(template : ReportTemplateField) -> Bool{
        if(!self.IsValidReportTemplate(template: template)){
            return false
        }
        let result = reportTemplateRepository.UpdateReportTemplate(template: template)
        if(result == -1){
            self.errorMessage = "Unable to update report template."
            return false
        }else{
            self.errorMessage = nil
        }
        return true
    }
    
    private func IsValidReportTemplate(template : ReportTemplateField) -> Bool{
        if(template.name.trimmingCharacters(in: .whitespaces).isEmpty){
            self.errorMessage = "Template name is required."
            return false
        }
        return true
    }
}
