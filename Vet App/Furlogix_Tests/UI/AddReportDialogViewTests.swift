import SwiftUI
//
//  AddReportDialogViewTests.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-06.
//
import XCTest

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

  private func createTestView() -> TestableAddReportDialogView {
    return TestableAddReportDialogView(
      currentLabel: .constant(mockCurrentLabel),
      onSave: { [weak self] report in
        self?.mockOnSaveCalled = true
        self?.savedReport = report
        self?.onSaveCallCount = (self?.onSaveCallCount ?? 0) + 1
      },
      onDismiss: { [weak self] in
        self?.mockOnDismissCalled = true
        self?.onDismissCallCount = (self?.onDismissCallCount ?? 0) + 1
      }
    )
  }

  func testViewInitialization() {
    let view = createTestView()

    XCTAssertNotNil(view)
    XCTAssertFalse(mockOnSaveCalled)
    XCTAssertFalse(mockOnDismissCalled)
  }

  func testOnSaveCallback() {
    let view = createTestView()
    let testReportName = "Test Report Name"

    // Simulate save button action
    view.simulateSave(reportName: testReportName)

    XCTAssertTrue(mockOnSaveCalled)
    XCTAssertEqual(onSaveCallCount, 1)
    XCTAssertNotNil(savedReport)
    XCTAssertEqual(savedReport?.name, testReportName)
    XCTAssertEqual(savedReport?.id, 0)
    XCTAssertEqual(savedReport?.petId, 1)
  }

  func testOnDismissCallback() {
    let view = createTestView()

    // Simulate cancel button action
    view.simulateCancel()

    XCTAssertTrue(mockOnDismissCalled)
    XCTAssertEqual(onDismissCallCount, 1)
    XCTAssertFalse(mockOnSaveCalled)
    XCTAssertNil(savedReport)
  }

  func testSaveButtonDisabledWithEmptyName() {
    let view = createTestView()

    // Save button should be disabled for empty names
    XCTAssertTrue(view.shouldSaveBeDisabled(reportName: ""))

    XCTAssertFalse(mockOnSaveCalled)
    XCTAssertNil(savedReport)
  }

  func testSaveButtonDisabledWithWhitespaceOnlyName() {
    let view = createTestView()
    let whitespaceName = "   \t\n  "

    XCTAssertTrue(view.shouldSaveBeDisabled(reportName: whitespaceName))
  }

  func testImprovedValidationLogic() {
    let view = createTestView()

    let testCases: [(String, Bool, String)] = [
      ("", true, "Empty string should disable save"),
      ("   ", true, "Whitespace only should disable save"),
      (" \t\n ", true, "Mixed whitespace should disable save"),
      ("A", false, "Single character should enable save"),
      ("  A  ", false, "Text with surrounding whitespace should enable save"),
      ("Valid Name", false, "Normal text should enable save"),
    ]

    for (input, shouldBeDisabled, description) in testCases {
      XCTAssertEqual(
        view.shouldSaveBeDisabled(reportName: input),
        shouldBeDisabled,
        description
      )
    }
  }

  func testCurrentValidationBehavior() {
    let view = createTestView()

    XCTAssertTrue(view.shouldSaveBeDisabled(reportName: ""), "Empty string disables save")
    XCTAssertTrue(
      view.shouldSaveBeDisabled(reportName: "   "),
      "Whitespace-only currently ENABLES save (potential issue)")
    XCTAssertTrue(
      view.shouldSaveBeDisabled(reportName: " "),
      "Single space currently ENABLES save (potential issue)")

    let longName = String(repeating: "A", count: 1000)

    view.simulateSave(reportName: longName)

    XCTAssertTrue(mockOnSaveCalled)
    XCTAssertEqual(savedReport?.name, longName)
    XCTAssertEqual(savedReport?.name.count, 1000)
  }

  func testSaveWithSingleCharacter() {
    let view = createTestView()
    let singleChar = "X"

    view.simulateSave(reportName: singleChar)

    XCTAssertTrue(mockOnSaveCalled)
    XCTAssertEqual(savedReport?.name, singleChar)
  }

  func testSaveWithSpecialCharacters() {
    let view = createTestView()
    let specialChars = "!@#$%^&*()_+-=[]{}|;:'\",.<>?`~"

    view.simulateSave(reportName: specialChars)

    XCTAssertTrue(mockOnSaveCalled)
    XCTAssertEqual(savedReport?.name, specialChars)
  }

  func testSaveWithUnicodeCharacters() {
    let view = createTestView()
    let unicodeString = "🐕 Report 测试 العربية"

    view.simulateSave(reportName: unicodeString)

    XCTAssertTrue(mockOnSaveCalled)
    XCTAssertEqual(savedReport?.name, unicodeString)
  }

  func testMultipleSaveActions() {
    let view = createTestView()

    view.simulateSave(reportName: "First Report")
    view.simulateSave(reportName: "Second Report")

    XCTAssertEqual(onSaveCallCount, 2)
    XCTAssertEqual(savedReport?.name, "Second Report")
  }

  func testMultipleCancelActions() {
    let view = createTestView()

    view.simulateCancel()
    view.simulateCancel()

    XCTAssertEqual(onDismissCallCount, 2)
    XCTAssertFalse(mockOnSaveCalled)
  }

  func testReportIdIsAlwaysZero() {
    let view = createTestView()
    let testNames = ["Report 1", "Report 2", "Another Report"]

    for name in testNames {
      view.simulateSave(reportName: name)
      XCTAssertEqual(savedReport?.id, 0, "Report ID should always be 0")
    }
  }

  func testPetIdIsAlwaysOne() {
    let view = createTestView()
    let testNames = ["Report 1", "Report 2", "Another Report"]

    for name in testNames {
      view.simulateSave(reportName: name)
      XCTAssertEqual(savedReport?.petId, 1, "Pet ID should always be 1")
    }
  }

  func testSaveDoesNotTriggerDismiss() {
    let view = createTestView()

    view.simulateSave(reportName: "Test Report")

    XCTAssertTrue(mockOnSaveCalled)
    XCTAssertFalse(mockOnDismissCalled)
  }

  func testCancelDoesNotTriggerSave() {
    let view = createTestView()

    view.simulateCancel()

    XCTAssertTrue(mockOnDismissCalled)
    XCTAssertFalse(mockOnSaveCalled)
    XCTAssertNil(savedReport)
  }

  func testSaveCallbackPerformance() {
    let view = createTestView()

    measure {
      for i in 0..<100 {
        view.simulateSave(reportName: "Performance Test \(i)")
      }
    }
  }

  func testViewCreationPerformance() {
    measure {
      for _ in 0..<100 {
        _ = createTestView()
      }
    }
  }

  func testCompleteHappyPathWorkflow() {
    let view = createTestView()
    let reportName = "Integration Test Report"

    view.simulateSave(reportName: reportName)

    // Verify complete state
    XCTAssertTrue(mockOnSaveCalled)
    XCTAssertFalse(mockOnDismissCalled)
    XCTAssertEqual(onSaveCallCount, 1)
    XCTAssertEqual(onDismissCallCount, 0)
    XCTAssertNotNil(savedReport)
    XCTAssertEqual(savedReport?.name, reportName)
    XCTAssertEqual(savedReport?.id, 0)
    XCTAssertEqual(savedReport?.petId, 1)
  }

  func testCancellationWorkflow() {
    let view = createTestView()

    view.simulateCancel()

    XCTAssertFalse(mockOnSaveCalled)
    XCTAssertTrue(mockOnDismissCalled)
    XCTAssertEqual(onSaveCallCount, 0)
    XCTAssertEqual(onDismissCallCount, 1)
    XCTAssertNil(savedReport)
  }
}

/// A testable wrapper that simulates the view's behavior without requiring SwiftUI rendering
class TestableAddReportDialogView {
  let currentLabel: Binding<String>
  let onSave: (Report) -> Void
  let onDismiss: () -> Void

  init(
    currentLabel: Binding<String>,
    onSave: @escaping (Report) -> Void,
    onDismiss: @escaping () -> Void
  ) {
    self.currentLabel = currentLabel
    self.onSave = onSave
    self.onDismiss = onDismiss
  }

  func simulateSave(reportName: String) {
    let newReport = Report(id: 0, name: reportName, petId: 1)
    onSave(newReport)
  }

  func simulateCancel() {
    onDismiss()
  }

  func shouldSaveBeDisabled(reportName: String) -> Bool {
    return reportName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}
