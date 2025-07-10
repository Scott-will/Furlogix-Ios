//
//  ReminderRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

class ReminderRepository : ReminderRepositoryProtocol{
    func insertReminder(reminder: Reminder) -> Bool {
        let result = RemindersStore.instance.insertReminder(reminder: reminder)
        return result == -1
    }
    
    func getAllReminders() -> [Reminder] {
        let result = RemindersStore.instance.getAllReminders()
        if(result == nil){
            AppLogger.error("Failed to retrieve reminders from store")
            return []
        }
        return result ?? []
    }
    
    func deleteReminder(reminderId : Int64) -> Bool {
        RemindersStore.instance.deleteReminder(reminderId: reminderId)
        return true
    }
}
