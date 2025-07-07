//
//  ReminderRepositoryProtocol.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

protocol ReminderRepositoryProtocol {
    func getAllReminders() -> [Reminder]
    
    func insertReminder() -> Bool
    
    func deleteReminder() -> Bool
    
}
