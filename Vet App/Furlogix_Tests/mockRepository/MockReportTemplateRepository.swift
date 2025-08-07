//
//  MockReportTemplateRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-08.
//

import Foundation
@testable import Furlogix

class MockReportTemplateRepository : ReportTemplateRepositoryProtocol {
    var fakeReportTemplates: [ReportTemplateField] = []
    var insertedReportTemplatess: [ReportTemplateField] = []
    var updatedReportTemplatess: [ReportTemplateField] = []
    var deletedReportTemplatesIds: [Int64] = []
    var fetchedReportTemplatesId: Int64?

    var insertShouldReturnNil = false
    var updateShouldReturnNil = false
    var deleteShouldReturnFalse = false
    var getShouldReturnFalse = false
    
    func GetTemplatesForReport(reportId: Int64) -> [ReportTemplateField] {
        if(getShouldReturnFalse){
            return []
        }
        return fakeReportTemplates
    }
    
    func GetTemplateById(templateId: Int64) -> ReportTemplateField? {
        if(getShouldReturnFalse){
            return nil
        }
        return fakeReportTemplates.first { $0.id == templateId }
    }
    
    func InsertReportTemplate(template: ReportTemplateField) -> Int64? {
        if(insertShouldReturnNil){
            return -1
        }
        insertedReportTemplatess.append(template)
        return 1
    }
    
    func UpdateReportTemplate(template: ReportTemplateField) -> Int64? {
        if(updateShouldReturnNil){
            return -1
        }
        updatedReportTemplatess.append(template)
        return 1
    }
    
    func DeleteReportTemplate(templateId: Int64) -> Bool {
        if(deleteShouldReturnFalse){
            return false
        }
        deletedReportTemplatesIds.append(templateId)
        return true
    }
    
    
}
