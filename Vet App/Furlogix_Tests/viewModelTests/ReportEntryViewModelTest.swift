//
//  ReportEntryViewModelTest.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-09.
//

import Testing

@testable import Furlogix

struct ReportEntryViewModelTests {
  @Test
  func testLoadReportEntryList_success() {
    let mockRepo = MockReportEntryRepository()
    mockRepo.fakeEntries = [
      ReportEntry(
        id: 1, value: "Temp", reportId: 10, templateId: 1, timestamp: "2024-07-10", sent: false),
      ReportEntry(
        id: 2, value: "Weight", reportId: 10, templateId: 2, timestamp: "2024-07-10", sent: false),
    ]
    let vm = ReportEntryViewModel(reportEntryRepositoryProtocol: mockRepo)
    vm.loadReportEntryList(reportId: 10)

    #expect(vm.reportEntryList.count == 2)
    #expect(vm.groupedEntries["2024-07-10"]?.count == 2)
    #expect(vm.errorMessage == nil)

  }

  @Test
  func testLoadReportEntryList_failure_nilResult() {
    let mockRepo = MockReportEntryRepository()
    mockRepo.shouldReturnNilOnGet = true

    let vm = ReportEntryViewModel(reportEntryRepositoryProtocol: mockRepo)
    vm.loadReportEntryList(reportId: 5)

    #expect(vm.reportEntryList.isEmpty)
    #expect(vm.groupedEntries.isEmpty)
    #expect(vm.errorMessage != nil)  // Only logs, does not set errorMessage

  }

  @Test
  func testInsertReportEntry_success_multipleEntries() {
    let mockRepo = MockReportEntryRepository()
    let vm = ReportEntryViewModel(reportEntryRepositoryProtocol: mockRepo)

    let values: [Int64: String] = [1: "BP", 2: "HR", 3: "Temp"]
    let result = vm.insertReportEntry(entryValues: values, reportId: 99, timestamp: "2024-07-11")

    #expect(result == true)
    #expect(mockRepo.fakeEntries.count == 3)
    #expect(vm.errorMessage == nil)

  }

  @Test
  func testInsertReportEntry_failure() {
    let mockRepo = MockReportEntryRepository()
    mockRepo.shouldFailInsert = true

    let vm = ReportEntryViewModel(reportEntryRepositoryProtocol: mockRepo)
    let values: [Int64: String] = [1: "Weight", 2: "Temp"]
    let result = vm.insertReportEntry(entryValues: values, reportId: 7, timestamp: "2024-07-12")

    #expect(result == false)
    #expect(vm.errorMessage != nil)
    #expect(mockRepo.fakeEntries.isEmpty)

  }

  @Test
  func testInsertReportEntry_emptyEntryValues() {
    let mockRepo = MockReportEntryRepository()
    let vm = ReportEntryViewModel(reportEntryRepositoryProtocol: mockRepo)

    let values: [Int64: String] = [:]
    let result = vm.insertReportEntry(entryValues: values, reportId: 4, timestamp: "2024-07-13")

    #expect(result == true)
    #expect(mockRepo.fakeEntries.isEmpty)
    #expect(vm.errorMessage == nil)

  }

  @Test
  func testLoadGroupedEntries_correctGrouping() {
    let mockRepo = MockReportEntryRepository()
    let vm = ReportEntryViewModel(reportEntryRepositoryProtocol: mockRepo)

    mockRepo.fakeEntries = [
      ReportEntry(
        id: 1, value: "Val1", reportId: 1, templateId: 1, timestamp: "2024-07-10", sent: false),
      ReportEntry(
        id: 2, value: "Val2", reportId: 1, templateId: 2, timestamp: "2024-07-10", sent: false),
      ReportEntry(
        id: 3, value: "Val3", reportId: 1, templateId: 3, timestamp: "2024-07-11", sent: false),
      ReportEntry(
        id: 4, value: "Val4", reportId: 1, templateId: 4, timestamp: "2024-07-11", sent: false),
      ReportEntry(
        id: 5, value: "Val5", reportId: 1, templateId: 5, timestamp: "2024-07-12", sent: false),
    ]

    vm.loadReportEntryList(reportId: 1)

    #expect(vm.groupedEntries["2024-07-10"]?.count == 2)
    #expect(vm.groupedEntries["2024-07-11"]?.count == 2)
    #expect(vm.groupedEntries["2024-07-12"]?.count == 1)

  }

  @Test
  func testLoadGroupedEntries_emptyList() {
    let mockRepo = MockReportEntryRepository()
    let vm = ReportEntryViewModel(reportEntryRepositoryProtocol: mockRepo)

    mockRepo.fakeEntries = []
    vm.loadReportEntryList(reportId: 1)

    #expect(vm.groupedEntries.isEmpty)

  }

  @Test

  func testInsertReportEntry_withLongTextValues() {
    let mockRepo = MockReportEntryRepository()
    let vm = ReportEntryViewModel(reportEntryRepositoryProtocol: mockRepo)

    let longText = String(repeating: "A", count: 1000)
    let values: [Int64: String] = [1: longText]
    let result = vm.insertReportEntry(entryValues: values, reportId: 33, timestamp: "2024-07-15")

    #expect(result == true)
    #expect(mockRepo.fakeEntries.count == 1)
    #expect(mockRepo.fakeEntries.first?.value == longText)
    #expect(vm.errorMessage == nil)

  }

  @Test
  func testInsertReportEntry_multipleReportsSeparation() {
    let mockRepo = MockReportEntryRepository()
    let vm = ReportEntryViewModel(reportEntryRepositoryProtocol: mockRepo)

    let values1: [Int64: String] = [1: "A"]
    let values2: [Int64: String] = [2: "B"]

    let res1 = vm.insertReportEntry(entryValues: values1, reportId: 101, timestamp: "2024-07-16")
    let res2 = vm.insertReportEntry(entryValues: values2, reportId: 102, timestamp: "2024-07-17")

    #expect(res1 == true)
    #expect(res2 == true)
    #expect(mockRepo.fakeEntries.count == 2)
    #expect(mockRepo.fakeEntries[0].reportId == 101)
    #expect(mockRepo.fakeEntries[1].reportId == 102)

  }

  @Test
  func testInsertReportEntry_EmptyTimestamp() {
    let mockRepo = MockReportEntryRepository()
    let vm = ReportEntryViewModel(reportEntryRepositoryProtocol: mockRepo)

    let values: [Int64: String] = [1: "A"]
    let result = vm.insertReportEntry(entryValues: values, reportId: 101, timestamp: "")
    #expect(result == false)
    #expect(vm.errorMessage != nil)
  }
}
