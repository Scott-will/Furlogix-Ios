//
//  ReportViewModelTest.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-08.
//

import Testing
@testable import Vet_App

struct ReportViewModelTest{
    
    @Test
    func LoadReportsForPet_Success() async throws {
        let mockRepo = MockReportRepository()
        mockRepo.fakeReports = [
            Report(id: 1, name: "Test 1", petId: 1),
            Report(id: 2, name: "Test 2", petId: 1)
        ]
        mockRepo.getShouldReturnFalse = false

        let vm = ReportViewModel(reportRepository: mockRepo)
        vm.GetReportsForPet(petId: 1)
        
        #expect(vm.reportsForPet.count == 2)
        #expect(vm.reportsForPet[0].name == "Test 1")
        #expect(vm.reportsForPet[1].name == "Test 2")
        #expect(vm.errorMessage == nil)
    }
    
    @Test
    func LoadReportsForPet_Fails() async throws {
        let mockRepo = MockReportRepository()
        mockRepo.fakeReports = [
            Report(id: 1, name: "Test 1", petId: 1),
            Report(id: 2, name: "Test 2", petId: 1)
        ]
        mockRepo.getShouldReturnFalse = true
        let vm = ReportViewModel(reportRepository: mockRepo)
        vm.GetReportsForPet(petId: 1)
        
        #expect(vm.reportsForPet.isEmpty)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func InsertReportsForPet_Success() async throws {
        let mockRepo = MockReportRepository()
        
        let vm = ReportViewModel(reportRepository: mockRepo)
        let result = vm.insertReport(name: "Test 1", petId: 1)
        
        #expect(result != -1)
        #expect(vm.errorMessage == nil)
    }
    
    @Test
    func InsertReportsForPet_Fails() async throws {
        let mockRepo = MockReportRepository()
        mockRepo.insertShouldReturnNil = true
        let vm = ReportViewModel(reportRepository: mockRepo)
        
        let result = vm.insertReport(name: "Test", petId: 1)
        
        #expect(result == -1)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func InsertReportsForPet_InvalidName_Fails() async throws {
        let mockRepo = MockReportRepository()

        let vm = ReportViewModel(reportRepository: mockRepo)
        
        let result = vm.insertReport(name: "", petId: 1)
        
        #expect(result == -1)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func DeleteReportsForPet_Success() async throws {
        let mockRepo = MockReportRepository()
        let vm = ReportViewModel(reportRepository: mockRepo)
        let result = vm.deleteReport(id: 1)
        
        #expect(result)
        #expect(vm.errorMessage == nil)
    }
    @Test
    func DeleteReportsForPet_Fails() async throws {
        let mockRepo = MockReportRepository()
        mockRepo.deleteShouldReturnFalse = true
        let vm = ReportViewModel(reportRepository: mockRepo)
        let result = vm.deleteReport(id: 1)
        
        #expect(!result)
        #expect(vm.errorMessage != nil)
        
    }
}
