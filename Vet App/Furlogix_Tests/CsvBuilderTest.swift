//
//  CsvBuilderTest.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

import XCTest

@testable import Vet_App

final class CsvBuilderTests: XCTestCase {

    var csvBuilder: CsvBuilder!

    override func setUp() {
        super.setUp()
        csvBuilder = CsvBuilder()
    }

    override func tearDown() {
        csvBuilder = nil
        super.tearDown()
    }

    func testBuildCsvWithSingleEntry() {
        let templates = [
            ReportTemplateField(id: 1, reportId: 1, name: "Test", fieldType: FieldType.Number),
            ReportTemplateField(id: 2, reportId: 1, name: "Test 2", fieldType: FieldType.Number),
        ]
        let entries = [
            ReportEntry(id: 1, value: "Test val", reportId: 1, templateId: 1, timestamp: "2025-07-10", sent: false),
            ReportEntry(id: 2, value: "Test val 2", reportId: 1, templateId: 2, timestamp: "2025-07-10", sent: false),
        ]

        let csv = csvBuilder.buildCsv(entries: entries, templates: templates)

        let expectedHeader = "Test,Test 2\n"
        let expectedLine = "\"Test val\",\"Test val 2\"\n"
        XCTAssertEqual(csv, expectedHeader + expectedLine)
    }

    func testBuildCsvWithMissingValues() {
        let templates = [
            ReportTemplateField(id: 1, reportId: 1, name: "Test", fieldType: FieldType.Number),
            ReportTemplateField(id: 2, reportId: 1, name: "Test 2", fieldType: FieldType.Number),
        ]
        let entries = [
            ReportEntry(id: 1, value: "Test val", reportId: 1, templateId: 1, timestamp: "2025-07-10", sent: false),
            // Missing entry for templateId 2
        ]

        let csv = csvBuilder.buildCsv(entries: entries, templates: templates)

        let expectedHeader = "Test,Test 2\n"
        let expectedLine = "\"Test val\",\"\"\n"
        XCTAssertEqual(csv, expectedHeader + expectedLine)
    }

    func testBuildAndWriteCsvCreatesFile() {
        let templates = [
            ReportTemplateField(id: 1, reportId: 1, name: "Test", fieldType: FieldType.Number),
            ReportTemplateField(id: 2, reportId: 1, name: "Test 2", fieldType: FieldType.Number),
        ]
        let entries = [
            ReportEntry(id: 1, value: "Test val", reportId: 1, templateId: 1, timestamp: "2025-07-10", sent: false),
            ReportEntry(id: 2, value: "Test val 2", reportId: 1, templateId: 2, timestamp: "2025-07-10", sent: false),
        ]

        let fileURL = csvBuilder.buildAndWriteCsv(reportName: "TestReport", entries: entries, templates: templates)

        XCTAssertNotNil(fileURL)

        if let fileURL = fileURL {
            XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path))

            if let fileContent = try? String(contentsOf: fileURL) {
                let expectedHeader = "Test,Test 2\n"
                let expectedLine = "\"Test val\",\"Test val 2\"\n"
                XCTAssertEqual(fileContent, expectedHeader + expectedLine)
            } else {
                XCTFail("Failed to read file content")
            }

            // Cleanup
            try? FileManager.default.removeItem(at: fileURL)
        }
    }

    func testBuildCsvWithMultipleTimestamps() {
        let templates = [
            ReportTemplateField(id: 1, reportId: 1, name: "Test", fieldType: FieldType.Number),
            ReportTemplateField(id: 2, reportId: 1, name: "Test 2", fieldType: FieldType.Number),
        ]
        let entries = [
            ReportEntry(id: 1, value: "Test val 3", reportId: 1, templateId: 1, timestamp: "2025-07-09", sent: false),
            ReportEntry(id: 2, value: "Test val 4", reportId: 1, templateId: 2, timestamp: "2025-07-09", sent: false),
            ReportEntry(id: 3, value: "Test val", reportId: 1, templateId: 1, timestamp: "2025-07-10", sent: false),
            ReportEntry(id: 4, value: "Test val 2", reportId: 1, templateId: 2, timestamp: "2025-07-10", sent: false),
        ]

        let csv = csvBuilder.buildCsv(entries: entries, templates: templates)

        let expectedHeader = "Test,Test 2\n"
        let expectedLines = "\"Test val 3\",\"Test val 4\"\n\"Test val\",\"Test val 2\"\n"
        XCTAssertEqual(csv, expectedHeader + expectedLines)
    }
}
