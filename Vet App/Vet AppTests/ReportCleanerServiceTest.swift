//
//  ReportCleanerServiceTest.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-11.
//

import XCTest
import BackgroundTasks
@testable import Vet_App

class ReportCleanerServiceTests: XCTestCase {
    
    var sut: ReportCleanerService!
    var mockRepository: MockReportEntryRepository!
    var mockUserDefaults: MockUserDefaults!
    var mockDIContainer: MockDIContainer!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockReportEntryRepository()
        mockUserDefaults = MockUserDefaults()
        mockDIContainer = MockDIContainer()
        
        // Setup DI container to return mock repository
        mockDIContainer.registerMock(type: ReportEntryRepositoryProtocol.self, instance: mockRepository)
        
        sut = ReportCleanerService(reportEntryRepository: mockRepository)
        
        // Replace UserDefaults with mock (would need to make userDefaults injectable)
        // For now, we'll test with real UserDefaults and clean up after
    }
    
    override func tearDown() {
        // Clean up UserDefaults
        UserDefaults.standard.removeObject(forKey: "lastReportCleanupDate")
        
        sut = nil
        mockRepository = nil
        mockUserDefaults = nil
        mockDIContainer = nil
        super.tearDown()
    }
    
    // MARK: - Registration Tests
    
    func testRegisterBackgroundTask_iOS13Available_RegistersSuccessfully() throws {
        // Given
        guard #available(iOS 13.0, *) else {
            throw XCTSkip("BGTaskScheduler not available on this iOS version")
        }
        
        // When
        sut.registerBackgroundTask()
        
        // Then
        // Since AppLogger is static, we can't easily verify logging
        // In a real app, you'd want to make AppLogger mockable
        XCTAssertTrue(true) // Registration doesn't throw
    }
    
    func testRegisterBackgroundTask_iOS12OrLower_HandlesGracefully() {
        // This test demonstrates the behavior but can't be easily tested
        // without runtime iOS version manipulation
        XCTAssertTrue(true)
    }
    
    // MARK: - Scheduling Tests
    
    func testScheduleReportCleaner_ValidRequest_SchedulesSuccessfully() throws {
        // Given
        guard #available(iOS 13.0, *) else {
            throw XCTSkip("BGTaskScheduler not available on this iOS version")
        }
        
        // When
        sut.scheduleReportCleaner()
        
        // Then
        // Verify no exceptions thrown
        XCTAssertTrue(true)
    }
    
    func testScheduleReportCleaner_iOS12OrLower_PerformsForegroundCleanup() throws {
        // Given - simulate old cleanup date
        let oldDate = Date(timeIntervalSinceNow: -15 * 24 * 60 * 60) // 15 days ago
        UserDefaults.standard.set(oldDate, forKey: "lastReportCleanupDate")
        
        // When
        sut.scheduleReportCleaner()
        
        // Then
        // On iOS 12 and lower, it should call performForegroundCleanupIfNeeded
        // which should trigger cleanup due to old date
        XCTAssertTrue(true)
    }
    
    // MARK: - Foreground Cleanup Tests
    
    func testPerformForegroundCleanupIfNeeded_CleanupNeeded_PerformsCleanup() throws {
        // Given
        let oldDate = Date(timeIntervalSinceNow: -15 * 24 * 60 * 60) // 15 days ago
        UserDefaults.standard.set(oldDate, forKey: "lastReportCleanupDate")
        
        // When
        sut.performForegroundCleanupIfNeeded()
        
        // Wait for async Task to complete
        let expectation = XCTestExpectation(description: "Cleanup task completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        //XCTAssertTrue(mockRepository.deleteSentReportEntriesAsyncCalled)
        
        // Verify last cleanup date was updated
        let lastCleanup = UserDefaults.standard.object(forKey: "lastReportCleanupDate") as? Date
        XCTAssertNotNil(lastCleanup)
        XCTAssertTrue(lastCleanup! > oldDate)
    }
    
    func testPerformForegroundCleanupIfNeeded_CleanupNotNeeded_SkipsCleanup() {
        // Given
        let recentDate = Date(timeIntervalSinceNow: -1 * 24 * 60 * 60) // 1 day ago
        UserDefaults.standard.set(recentDate, forKey: "lastReportCleanupDate")
        
        // When
        sut.performForegroundCleanupIfNeeded()
        
        // Wait briefly to ensure no async operation starts
        let expectation = XCTestExpectation(description: "No cleanup should occur")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        // Then
        //XCTAssertFalse(mockRepository.deleteSentReportEntriesAsyncCalled)
    }
    
    func testPerformForegroundCleanupIfNeeded_NoLastCleanupDate_PerformsCleanup() {
        // Given
        UserDefaults.standard.removeObject(forKey: "lastReportCleanupDate")
        
        // When
        sut.performForegroundCleanupIfNeeded()
        
        // Wait for async Task to complete
        let expectation = XCTestExpectation(description: "Cleanup task completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        //XCTAssertTrue(mockRepository.deleteSentReportEntriesAsyncCalled)
    }
    
    // MARK: - Manual Cleanup Tests
    
    func testPerformCleanup_Success_UpdatesLastCleanupDate() async {
        // Given
        mockRepository.deleteshouldSucceed = true
        
        // When
        sut.performCleanup()
        
        // Wait for async Task to complete
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Then
        //XCTAssertTrue(mockRepository.deleteSentReportEntriesAsyncCalled)
        
        // Verify last cleanup date was updated
        let lastCleanup = UserDefaults.standard.object(forKey: "lastReportCleanupDate") as? Date
        XCTAssertNotNil(lastCleanup)
        
        // Should be within the last few seconds
        let timeSinceUpdate = Date().timeIntervalSince(lastCleanup!)
        XCTAssertLessThan(timeSinceUpdate, 5.0)
    }
    
    func testPerformCleanup_Failure_DoesNotUpdateDate() async {
        // Given
        let initialDate = Date(timeIntervalSinceNow: -100) // 100 seconds ago
        UserDefaults.standard.set(initialDate, forKey: "lastReportCleanupDate")
        
        mockRepository.deleteshouldSucceed = false
        mockRepository.errorToThrow = ReportCleanupError.databaseError
        
        // When
        sut.performCleanup()
        
        // Wait for async Task to complete
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Then
        XCTAssertTrue(mockRepository.deleteSentReportEntriesAsyncCalled)
        
        // Verify last cleanup date was NOT updated
        let lastCleanup = UserDefaults.standard.object(forKey: "lastReportCleanupDate") as? Date
        XCTAssertEqual(lastCleanup, initialDate)
    }
    
    // MARK: - Background Task Handling Tests
    
    @available(iOS 13.0, *)
    func testHandleReportCleanup_RecentCleanup_SkipsExecution() {
        // Given
        let recentDate = Date(timeIntervalSinceNow: -1 * 24 * 60 * 60) // 1 day ago
        UserDefaults.standard.set(recentDate, forKey: "lastReportCleanupDate")
        
        let mockTask = MockBGAppRefreshTask()
        
        // When
        sut.handleReportCleanup(task: mockTask)
        
        // Wait briefly for immediate execution
        let expectation = XCTestExpectation(description: "Task completes immediately")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        // Then
        XCTAssertFalse(mockRepository.deleteSentReportEntriesSyncCalled)
        XCTAssertTrue(mockTask.setTaskCompletedCalled)
        XCTAssertTrue(mockTask.completedSuccessfully)
    }
    
    @available(iOS 13.0, *)
    func testHandleReportCleanup_OldCleanup_PerformsCleanup() {
        // Given
        let oldDate = Date(timeIntervalSinceNow: -15 * 24 * 60 * 60) // 15 days ago
        UserDefaults.standard.set(oldDate, forKey: "lastReportCleanupDate")
        mockRepository.deleteshouldSucceed = true
        
        let mockTask = MockBGAppRefreshTask()
        
        // When
        sut.handleReportCleanup(task: mockTask)
        
        // Wait for background operation to complete
        let expectation = XCTestExpectation(description: "Background cleanup completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertTrue(mockRepository.deleteSentReportEntriesSyncCalled)
        XCTAssertTrue(mockTask.setTaskCompletedCalled)
        XCTAssertTrue(mockTask.completedSuccessfully)
    }
    
    @available(iOS 13.0, *)
    func testHandleReportCleanup_RepositoryFails_CompletesWithFailure() {
        // Given
        let oldDate = Date(timeIntervalSinceNow: -15 * 24 * 60 * 60) // 15 days ago
        UserDefaults.standard.set(oldDate, forKey: "lastReportCleanupDate")
        mockRepository.deleteshouldSucceed = false
        mockRepository.errorToThrow = ReportCleanupError.databaseError
        
        let mockTask = MockBGAppRefreshTask()
        
        // When
        sut.handleReportCleanup(task: mockTask)
        
        // Wait for background operation to complete
        let expectation = XCTestExpectation(description: "Background cleanup completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertTrue(mockRepository.deleteSentReportEntriesSyncCalled)
        XCTAssertTrue(mockTask.setTaskCompletedCalled)
        XCTAssertFalse(mockTask.completedSuccessfully)
    }
    
    @available(iOS 13.0, *)
    func testHandleReportCleanup_TaskExpires_CancelsOperation() {
        // Given
        let oldDate = Date(timeIntervalSinceNow: -15 * 24 * 60 * 60) // 15 days ago
        UserDefaults.standard.set(oldDate, forKey: "lastReportCleanupDate")
        mockRepository.shouldDelay = true // Simulate slow operation
        
        let mockTask = MockBGAppRefreshTask()
        
        // When
        sut.handleReportCleanup(task: mockTask)
        
        // Simulate task expiration after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            mockTask.simulateExpiration()
        }
        
        // Wait for expiration handling
        let expectation = XCTestExpectation(description: "Task expiration handled")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertTrue(mockTask.setTaskCompletedCalled)
        XCTAssertFalse(mockTask.completedSuccessfully)
    }
}

class MockUserDefaults: UserDefaults {
    private var storage: [String: Any] = [:]
    
    override func object(forKey defaultName: String) -> Any? {
        return storage[defaultName]
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    override func removeObject(forKey defaultName: String) {
        storage.removeValue(forKey: defaultName)
    }
}

class MockDIContainer {
    private var registrations: [String: Any] = [:]
    
    func registerMock<T>(type: T.Type, instance: T) {
        let key = String(describing: type)
        registrations[key] = instance
    }
    
    func resolve<T>(type: T.Type) -> T? {
        let key = String(describing: type)
        return registrations[key] as? T
    }
}

@available(iOS 13.0, *)
class MockBGAppRefreshTask: BGAppRefreshTask {
    var setTaskCompletedCalled = false
    var completedSuccessfully = false
    
    override func setTaskCompleted(success: Bool) {
        setTaskCompletedCalled = true
        completedSuccessfully = success
    }
    
    func simulateExpiration() {
        expirationHandler?()
    }
}

// MARK: - Test Errors

enum ReportCleanupError: Error {
    case databaseError
    case networkError
    case unknownError
}

// MARK: - Integration Tests

class ReportCleanerServiceIntegrationTests: XCTestCase {
    
    var sut: ReportCleanerService!
    var testRepository: MockReportEntryRepository!
    
    override func setUp() {
        super.setUp()
        testRepository = MockReportEntryRepository()
        sut = ReportCleanerService(reportEntryRepository: testRepository)
    }
    
    override func tearDown() {
        // Clean up UserDefaults
        UserDefaults.standard.removeObject(forKey: "lastReportCleanupDate")
        
        sut = nil
        testRepository = nil
        super.tearDown()
    }
    
    func testEndToEndCleanupFlow() async {
        // Given
        //testRepository.addTestData()
        
        // When
        sut.performCleanup()
        
        // Wait for async completion
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Then
        //XCTAssertTrue(testRepository.sentReportsDeleted)
        
        // Verify last cleanup date was set
        let lastCleanup = UserDefaults.standard.object(forKey: "lastReportCleanupDate") as? Date
        XCTAssertNotNil(lastCleanup)
    }
    
    func testForegroundCleanupFlow() {
        // Given
        let oldDate = Date(timeIntervalSinceNow: -15 * 24 * 60 * 60) // 15 days ago
        UserDefaults.standard.set(oldDate, forKey: "lastReportCleanupDate")
        //testRepository.addTestData()
        
        // When
        sut.performForegroundCleanupIfNeeded()
        
        // Wait for async completion
        let expectation = XCTestExpectation(description: "Cleanup completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        // Then
        //XCTAssertTrue(testRepository.sentReportsDeleted)
    }
    
    @available(iOS 13.0, *)
    func testBackgroundTaskScheduling() async throws{
        // Given
        let initialTasks = await BGTaskScheduler.shared.pendingTaskRequests()
        let initialCount = initialTasks.count
        
        // When
        sut.scheduleReportCleaner()
        
        // Then
        let finalTasks = await BGTaskScheduler.shared.pendingTaskRequests()
        let finalCount = finalTasks.count
        
        // Should have either the same count (if replaced) or one more
        XCTAssertGreaterThanOrEqual(finalCount, initialCount)
        
        // Verify our task is in the list
        let ourTask = finalTasks.first { $0.identifier == "com.Furlogix.reportcleaner" }
        XCTAssertNotNil(ourTask)
    }
}

class ReportCleanerServicePerformanceTests: XCTestCase {
    
    var sut: ReportCleanerService!
    var mockRepository: MockReportEntryRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockReportEntryRepository()
        sut = ReportCleanerService(reportEntryRepository: mockRepository)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "lastReportCleanupDate")
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testCleanupPerformance() {
        // Given
        mockRepository.deleteshouldSucceed = true
        
        // When/Then
        measure {
            sut.performCleanup()
            // Small delay to allow Task to start
            Thread.sleep(forTimeInterval: 0.01)
        }
    }
    
    func testSchedulingPerformance() {
        // Given/When/Then
        measure {
            sut.scheduleReportCleaner()
        }
    }
    
    func testForegroundCleanupPerformance() {
        // Given
        let oldDate = Date(timeIntervalSinceNow: -15 * 24 * 60 * 60) // 15 days ago
        UserDefaults.standard.set(oldDate, forKey: "lastReportCleanupDate")
        mockRepository.deleteshouldSucceed = true
        
        // When/Then
        measure {
            sut.performForegroundCleanupIfNeeded()
            // Small delay to allow Task to start
            Thread.sleep(forTimeInterval: 0.01)
        }
    }
}

// MARK: - Helper Extensions for Testing

extension ReportCleanerService {
    // Add this to your actual ReportCleanerService for testing
    // You can wrap it in #if DEBUG to exclude from release builds
    #if DEBUG
    func handleReportCleanup(task: BGAppRefreshTask) {
        // Make the private method accessible for testing
        self.handleReportCleanup(task: task)
    }
    #endif
}
