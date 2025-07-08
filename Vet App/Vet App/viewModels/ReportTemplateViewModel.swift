//
//  ReportTemplateViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//

import Foundation

class ReportTemplateViewModel : ObservableObject{
    @Published var errorMsg : String? = nil

    @Published var templatesForReports : [ReportTemplateField] = []
    
    private let reportTemplateRepository : ReportTemplateRepositoryProtocol
    
    init( reportTemplateRepository : ReportTemplateRepositoryProtocol = DIContainer.shared.resolve(type: ReportTemplateRepositoryProtocol.self)!){
        self.reportTemplateRepository = reportTemplateRepository
    }
    
    public func GetReportTemplateForReport(reportId : Int64){
        self.templatesForReports = reportTemplateRepository.GetTemplatesForReport(reportId: reportId)
    }
    
    public func InsertReportTemplate(name : String, reportId : Int64, type : FieldType) -> Int64?{
        let template = ReportTemplateField(id: -1, reportId: reportId, name: name, favourite: false, fieldType: type)
        return reportTemplateRepository.InsertReportTemplate(template: template)
    }
}
