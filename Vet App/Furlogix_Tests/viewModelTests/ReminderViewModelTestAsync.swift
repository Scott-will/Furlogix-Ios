//
//  ReminderViewModelTestAsync.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

@testable import Furlogix
import XCTest

class ReminderViewModelTestAsync : XCTestCase {
    
    func test_insertReminder_Success() {
        let mockRepo = MockReminderRepository()
        let mockNotificationService = MockUserNotificationService()
        mockNotificationService.shouldGrantPermission = true
        mockNotificationService.shouldScheduleSuccess = true

        let vm = ReminderViewModel(remindersRepository: mockRepo, userNotificationService: mockNotificationService)

        let reminder = Reminder(id: 1, frequency: "once", startTime: "2025-07-10, 11:00 AM", title: "Test", message: "Test", requestId: "abc")

        let expectation = XCTestExpectation(description: "Notification scheduled successfully")

        vm.insertReminder(reminder: reminder)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(vm.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    
    func test_insertReminder_FailureToSchedule() {
        let mockRepo = MockReminderRepository()
        let mockNotificationService = MockUserNotificationService()
        mockNotificationService.shouldGrantPermission = true
        mockNotificationService.shouldScheduleSuccess = false

        let vm = ReminderViewModel(remindersRepository: mockRepo, userNotificationService: mockNotificationService)

        let reminder = Reminder(id: 2, frequency: "once", startTime: "2025-07-10, 11:00 AM", title: "Test", message: "Test", requestId: "abc")

        let expectation = XCTestExpectation(description: "Notification scheduling failed")

        vm.insertReminder(reminder: reminder)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(vm.errorMessage)
            XCTAssertTrue(mockRepo.deletedReminders.contains(reminder.id))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
