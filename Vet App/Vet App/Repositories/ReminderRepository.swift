//
//  ReminderRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

class ReminderRepository : ReminderRepositoryProtocol{
    func getAllReminders() -> [Reminder] {
        return []
    }
    
    func insertReminder() -> Bool {
        return true
    }
    
    func deleteReminder() -> Bool {
        return true
    }
}
