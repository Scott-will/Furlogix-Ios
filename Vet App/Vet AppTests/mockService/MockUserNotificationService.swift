//
//  MockUserNotificationService.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

@testable import Vet_App

class MockUserNotificationService : UserNotificationServiceProtocol{
    var shouldGrantPermission: Bool = true
        var shouldScheduleSuccess: Bool = true
        var canceledRequestIds: [String] = []

        func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
            completion(shouldGrantPermission)
        }
        
        func scheduleReminderNotification(reminder: Vet_App.Reminder, completion: @escaping (Bool) -> Void) {
            completion(shouldScheduleSuccess)
        }
        
        func cancelReminderNotificationService(reminderRequestId: String) {
            canceledRequestIds.append(reminderRequestId)
        }
}
