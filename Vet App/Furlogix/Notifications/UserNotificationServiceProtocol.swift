//
//  UserNotificationServiceProtocol.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

protocol UserNotificationServiceProtocol{
    
    func requestNotificationPermission(completion: @escaping (Bool) -> Void)
    
    func scheduleReminderNotification(reminder: Reminder, completion: @escaping (Bool) -> Void)
    
    func cancelReminderNotificationService(reminderRequestId : String)
    
    
}
