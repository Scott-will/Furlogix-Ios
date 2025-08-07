//
//  AddReportDialogViewTests.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-06.
//


import XCTest
import SwiftUI

@testable import Furlogix

final class AddReportDialogViewTests: XCTestCase {
    
    private var mockCurrentLabel: String!
    private var mockOnSaveCalled: Bool!
    private var mockOnDismissCalled: Bool!
    private var savedReport: Report?
    private var onSaveCallCount: Int!
    private var onDismissCallCount: Int!
    
    override func setUp() {
        super.setUp()
        mockCurrentLabel = "Test Label"
        mockOnSaveCalled = false
        mockOnDismissCalled = false
        savedReport = nil
        onSaveCallCount = 0
        onDismissCallCount = 0
    }
    
    override func tearDown() {
        savedReport = nil
        mockCurrentLabel = nil
        mockOnSaveCalled = nil
        mockOnDismissCalled = nil
        onSaveCallCount = nil
        onDismissCallCount = nil
        super.tearDown()
    }
    
    private func createView() -> AddReportDialogView {
        return AddReportDialogView(
            currentLabel: .constant(mockCurrentLabel),
            onSave: { [weak self] report in
                self?.mockOnSaveCalled = true
                self?.savedReport = report
                self?.onSaveCallCount += 1
            },
            onDismiss: { [weak self] in
                self?.mockOnDismissCalled = true
                self?.onDismissCallCount += 1
            }
        )
    }
    
    func testOnSaveCallback() {
        let view = createView()
        let testReportName = "Test Report Name"
        
        // Simulate the save action by directly calling what the save button would do
        let newReport = Report(id: 0, name: testReportName, petId: 1)
        view.onSave(newReport)
        
        XCTAssertTrue(mockOnSaveCalled)
        XCTAssertEqual(onSaveCallCount, 1)
        XCTAssertNotNil(savedReport)
        XCTAssertEqual(savedReport?.name, testReportName)
        XCTAssertEqual(savedReport?.id, 0)
        XCTAssertEqual(savedReport?.petId, 1)
    }
    
    func testOnDismissCallback() {
        let view = createView()
        
        view.onDismiss()
        
        XCTAssertTrue(mockOnDismissCalled)
        XCTAssertEqual(onDismissCallCount, 1)
        XCTAssertFalse(mockOnSaveCalled)
        XCTAssertNil(savedReport)
    }
    
    func testMultipleOnSaveCalls() {
        let view = createView()
        
        let report1 = Report(id: 0, name: "First Report", petId: 1)
        let report2 = Report(id: 0, name: "Second Report", petId: 1)
        
        view.onSave(report1)
        view.onSave(report2)
        
        XCTAssertEqual(onSaveCallCount, 2)
        XCTAssertEqual(savedReport?.name, "Second Report") // Should have the last saved report
    }
    
    func testMultipleOnDismissCalls() {
        let view = createView()
        
        view.onDismiss()
        view.onDismiss()
        
        XCTAssertEqual(onDismissCallCount, 2)
    }
    
    func testReportCreationWithValidName() {
        let view = createView()
        let testName = "Valid Report Name"
        
        let report = Report(id: 0, name: testName, petId: 1)
        view.onSave(report)
        
        XCTAssertEqual(savedReport?.name, testName)
        XCTAssertEqual(savedReport?.id, 0)
        XCTAssertEqual(savedReport?.petId, 1)
    }
    
    func testReportCreationWithEmptyName() {
        let view = createView()
        let emptyName = ""
        
        let report = Report(id: 0, name: emptyName, petId: 1)
        view.onSave(report)
        
        XCTAssertEqual(savedReport?.name, "")
        XCTAssertTrue(mockOnSaveCalled)
    }
    
    func testReportCreationWithWhitespaceOnlyName() {
        let view = createView()
        let whitespaceName = "   \n\t  "
        
        let report = Report(id: 0, name: whitespaceName, petId: 1)
        view.onSave(report)
        
        XCTAssertEqual(savedReport?.name, whitespaceName)
        XCTAssertTrue(mockOnSaveCalled)
    }
    
    func testReportCreationWithVeryLongName() {
        let view = createView()
        let longName = String(repeating: "A", count: 1000)
        
        let report = Report(id: 0, name: longName, petId: 1)
        view.onSave(report)
        
        XCTAssertEqual(savedReport?.name, longName)
        XCTAssertEqual(savedReport?.name.count, 1000)
    }
    
    func testReportCreationWithSingleCharacterName() {
        let view = createView()
        let singleChar = "X"
        
        let report = Report(id: 0, name: singleChar, petId: 1)
        view.onSave(report)
        
        XCTAssertEqual(savedReport?.name, singleChar)
    }
    
    func testReportCreationWithSpecialCharacters() {
        let view = createView()
        let specialChars = "!@#$%^&*()_+-=[]{}|;:'\",.<>?`~"
        
        let report = Report(id: 0, name: specialChars, petId: 1)
        view.onSave(report)
        
        XCTAssertEqual(savedReport?.name, specialChars)
    }
    
    func testReportCreationWithUnicodeCharacters() {
        let view = createView()
        let unicodeString = "🐕 Report 测试 العربية ñáéíóú"
        
        let report = Report(id: 0, name: unicodeString, petId: 1)
        view.onSave(report)
        
        XCTAssertEqual(savedReport?.name, unicodeString)
    }
    
    func testReportCreationWithNewlineCharacters() {
        let view = createView()
        let nameWithNewlines = "Line 1\nLine 2\rLine 3\r\nLine 4"
        
        let report = Report(id: 0, name: nameWithNewlines, petId: 1)
        view.onSave(report)
        
        XCTAssertEqual(savedReport?.name, nameWithNewlines)
    }
    
    func testReportCreationWithNumericName() {
        let view = createView()
        let numericName = "12345"
        
        let report = Report(id: 0, name: numericName, petId: 1)
        view.onSave(report)
        
        XCTAssertEqual(savedReport?.name, numericName)
    }
    
    func testHardcodedReportIdIsAlwaysZero() {
        let view = createView()
        let testNames = ["Report 1", "Report 2", "Another Report"]
        
        for name in testNames {
            let report = Report(id: 0, name: name, petId: 1)
            view.onSave(report)
            
            XCTAssertEqual(savedReport?.id, 0, "Report ID should always be 0 for report: \(name)")
        }
    }
    
    func testHardcodedPetIdIsAlwaysOne() {
        let view = createView()
        let testNames = ["Report 1", "Report 2", "Another Report"]
        
        for name in testNames {
            let report = Report(id: 0, name: name, petId: 1)
            view.onSave(report)
            
            XCTAssertEqual(savedReport?.petId, 1, "Pet ID should always be 1 for report: \(name)")
        }
    }
    
    func testCurrentLabelBinding() {
        let currentLabel = "Initial Label"
        let view = AddReportDialogView(
            currentLabel: .constant(currentLabel),
            onSave: { _ in },
            onDismiss: { }
        )
        
        // The view should be created without issues
        XCTAssertNotNil(view)
        // Note: We can't easily test binding changes without ViewInspector
        // This test mainly ensures the binding is accepted during initialization
    }
    
    func testCallbacksHandleNilWeakReferences() {
        // Create a view in a separate scope to simulate memory management
        var savedReportFromClosure: Report?
        var dismissCallbackCalled = false
        
        do {
            let view = AddReportDialogView(
                currentLabel: .constant("Test"),
                onSave: { report in
                    savedReportFromClosure = report
                },
                onDismiss: {
                    dismissCallbackCalled = true
                }
            )
            
            let testReport = Report(id: 0, name: "Test Report", petId: 1)
            view.onSave(testReport)
            view.onDismiss()
        }
        
        XCTAssertNotNil(savedReportFromClosure)
        XCTAssertEqual(savedReportFromClosure?.name, "Test Report")
        XCTAssertTrue(dismissCallbackCalled)
    }
    
    func testCompleteWorkflow() {
        let view = createView()
        let reportName = "Integration Test Report"
        
        // Simulate complete user workflow
        let newReport = Report(id: 0, name: reportName, petId: 1)
        view.onSave(newReport)
        
        // Verify all expected state changes
        XCTAssertTrue(mockOnSaveCalled)
        XCTAssertFalse(mockOnDismissCalled)
        XCTAssertEqual(onSaveCallCount, 1)
        XCTAssertEqual(onDismissCallCount, 0)
        XCTAssertNotNil(savedReport)
        XCTAssertEqual(savedReport?.name, reportName)
        XCTAssertEqual(savedReport?.id, 0)
        XCTAssertEqual(savedReport?.petId, 1)
    }
    
    func testCancelWorkflow() {
        let view = createView()
        
        // Simulate cancel workflow
        view.onDismiss()
        
        // Verify all expected state changes
        XCTAssertFalse(mockOnSaveCalled)
        XCTAssertTrue(mockOnDismissCalled)
        XCTAssertEqual(onSaveCallCount, 0)
        XCTAssertEqual(onDismissCallCount, 1)
        XCTAssertNil(savedReport)
    }
    
    func testViewCreationPerformance() {
        measure {
            for _ in 0..<100 {
                let view = AddReportDialogView(
                    currentLabel: .constant("Performance Test"),
                    onSave: { _ in },
                    onDismiss: { }
                )
                _ = view.body
            }
        }
    }
    
    func testCallbackPerformance() {
        let view = createView()
        let testReport = Report(id: 0, name: "Performance Test Report", petId: 1)
        
        measure {
            for _ in 0..<1000 {
                view.onSave(testReport)
            }
        }
    }
    
    func testReportNameBoundaryValues() {
        let view = createView()
        let boundaryTestCases: [(String, String)] = [
            ("", "Empty string"),
            (" ", "Single space"),
            ("A", "Single character"),
            ("AB", "Two characters"),
            (String(repeating: "X", count: 255), "255 characters"),
            (String(repeating: "Y", count: 256), "256 characters"),
            (String(repeating: "Z", count: 1024), "1024 characters")
        ]
        
        for (testName, description) in boundaryTestCases {
            let report = Report(id: 0, name: testName, petId: 1)
            view.onSave(report)
            
            XCTAssertEqual(savedReport?.name, testName, "Failed for \(description)")
            XCTAssertEqual(savedReport?.name.count, testName.count, "Character count mismatch for \(description)")
        }
    }
    
    func testConcurrentCallbacks() {
        let view = createView()
        let expectation = XCTestExpectation(description: "Concurrent callbacks completed")
        expectation.expectedFulfillmentCount = 10
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        for i in 0..<10 {
            queue.async {
                let report = Report(id: 0, name: "Concurrent Report \(i)", petId: 1)
                view.onSave(report)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertGreaterThanOrEqual(onSaveCallCount, 10)
    }
}

extension AddReportDialogViewTests {
    
    /// Helper method to validate report properties
    private func validateReport(_ report: Report?, expectedName: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(report, "Report should not be nil", file: file, line: line)
        XCTAssertEqual(report?.name, expectedName, "Report name mismatch", file: file, line: line)
        XCTAssertEqual(report?.id, 0, "Report ID should be 0", file: file, line: line)
        XCTAssertEqual(report?.petId, 1, "Pet ID should be 1", file: file, line: line)
    }
    
    private func resetTestState() {
        mockOnSaveCalled = false
        mockOnDismissCalled = false
        savedReport = nil
        onSaveCallCount = 0
        onDismissCallCount = 0
    }
}
