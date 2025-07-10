//
//  MockReminderRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

import Foundation
@testable import Vet_App

class MockReminderRepository : ReminderRepositoryProtocol {
    
    var fakeReminders : [Reminder] = []
    var insertShouldReturnNil = false
    var deleteShouldReturnFalse = false
    var deletedReminders : [Int64] = []

    func getAllReminders() -> [Vet_App.Reminder] {
        return fakeReminders
    }
    
    func insertReminder(reminder: Vet_App.Reminder) -> Int64 {
        if(insertShouldReturnNil){
            return -1
        }
        return 1
    }
    
    func deleteReminder(reminderId: Int64) -> Bool {
        if(deleteShouldReturnFalse){
            return false
        }
        deletedReminders.append(reminderId)
        return true
    }
    
    
}
