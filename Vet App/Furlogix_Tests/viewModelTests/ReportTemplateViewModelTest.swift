//
//  ReportTemplateViewModelTest.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-08.
//

import Testing
@testable import Furlogix

struct ReportTemplateViewModelTest{
    
    @Test
    func GetReportTemplate_ForReport_Success() async throws {
        let mockRepo = MockReportTemplateRepository()
        mockRepo.fakeReportTemplates = [
            ReportTemplateField(reportId: 1, name: "Test 1", fieldType: FieldType.Number, icon: "", units: ""),
            ReportTemplateField(reportId: 1, name: "Test 2", fieldType: FieldType.Boolean, icon: "", units: ""),
        ]
        
        let vm = ReportTemplateViewModel(reportTemplateRepository: mockRepo)
        vm.GetReportTemplateForReport(reportId: 1)
        
        #expect(vm.templatesForReports.count == 2)
        #expect(vm.templatesForReports[0].name == "Test 1")
        #expect(vm.errorMessage == nil)
        
    }
    
    @Test
    func GetReportTemplate_ForReport_Fails() async throws {
        let mockRepo = MockReportTemplateRepository()
        mockRepo.fakeReportTemplates = [
            ReportTemplateField(reportId: 1, name: "Test 1", fieldType: FieldType.Number, icon: "", units: ""),
            ReportTemplateField(reportId: 1, name: "Test 2", fieldType: FieldType.Boolean, icon: "", units: ""),
            ReportTemplateField(reportId: 2, name: "Test 2", fieldType: FieldType.Text, icon: "", units: "")
        ]
        mockRepo.getShouldReturnFalse = true
        let vm = ReportTemplateViewModel(reportTemplateRepository: mockRepo)
        vm.GetReportTemplateForReport(reportId: 1)
        
        #expect(vm.templatesForReports.count == 0)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func InsertReportTemplate_Success() async throws {
        let mockRepo = MockReportTemplateRepository()
        let template = ReportTemplateField(reportId: 2, name: "Test 1", fieldType: FieldType.Text, icon: "", units: "")
        
        let vm = ReportTemplateViewModel(reportTemplateRepository: mockRepo)
        let result = vm.InsertReportTemplate(template: template)
        
        #expect(result != -1)
        #expect(vm.errorMessage == nil)

    }
    
    @Test
    func InsertReportTemplate_Fails() async throws {
        let mockRepo = MockReportTemplateRepository()
        mockRepo.insertShouldReturnNil = true
        let template = ReportTemplateField(reportId: 2, name: "Test 1", fieldType: FieldType.Text, icon: "", units: "")

        let vm = ReportTemplateViewModel(reportTemplateRepository: mockRepo)
        let result = vm.InsertReportTemplate(template: template)
        #expect(result == -1)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func InsertReportTemplate_EmptyName_Fails() async throws {
        let mockRepo = MockReportTemplateRepository()
        let template = ReportTemplateField(reportId: 2, name: "", fieldType: FieldType.Text, icon: "", units: "")

        let vm = ReportTemplateViewModel(reportTemplateRepository: mockRepo)
        let result = vm.InsertReportTemplate(template: template)
        #expect(result == -1)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func UpdateReportTemplate_Success() async throws {
        let mockRepo = MockReportTemplateRepository()
        let template = ReportTemplateField(reportId: 2, name: "test update", fieldType: FieldType.Text, icon: "", units: "")

        let vm = ReportTemplateViewModel(reportTemplateRepository: mockRepo)
        let result = vm.UpdateReportTemplate(template: template)
        
        #expect(result == true)
        #expect(vm.errorMessage == nil)
    }
    
    @Test
    func UpdateReportTemplate_Fails() async throws {
        let mockRepo = MockReportTemplateRepository()
        mockRepo.updateShouldReturnNil = true
        let template = ReportTemplateField(reportId: 2, name: "test update", fieldType: FieldType.Text, icon: "", units: "")

        let vm = ReportTemplateViewModel(reportTemplateRepository: mockRepo)
        let result = vm.UpdateReportTemplate(template: template)
        
        #expect(result == false)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func UpdateReportTemplate_EmptyName_Fails() async throws {
        let mockRepo = MockReportTemplateRepository()
        let template = ReportTemplateField(reportId: 2, name: "", fieldType: FieldType.Text, icon: "", units: "")

        let vm = ReportTemplateViewModel(reportTemplateRepository: mockRepo)
        let result = vm.UpdateReportTemplate(template: template)
        
        #expect(result == false)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func DeleteReportTemplate_Success() async throws {
        let mockRepo = MockReportTemplateRepository()
        
        let vm = ReportTemplateViewModel(reportTemplateRepository: mockRepo)
        let result = vm.DeleteReportTemplate(templateId: 1)
        
        #expect(result == true)
        #expect(vm.errorMessage == nil)
    }
    
    @Test
    func DeleteReportTemplate_Fails() async throws {
        let mockRepo = MockReportTemplateRepository()
        mockRepo.deleteShouldReturnFalse = true
        let vm = ReportTemplateViewModel(reportTemplateRepository: mockRepo)
        let result = vm.DeleteReportTemplate(templateId: 1)
        
        #expect(result == false)
        #expect(vm.errorMessage != nil)
    }
}
