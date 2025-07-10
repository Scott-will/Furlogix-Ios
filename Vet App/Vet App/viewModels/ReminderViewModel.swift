//
//  ReminderViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

import Foundation

class ReminderViewModel : ObservableObject, ErrorMessageProvider{
    @Published var errorMessage: String? = nil
    private var reminderRepository: ReminderRepositoryProtocol
    
    @Published var reminders: [Reminder] = []
    
    init(remindersRepository : ReminderRepositoryProtocol = DIContainer.shared.resolve(type: ReminderRepositoryProtocol.self)!) {
        self.reminderRepository = remindersRepository
    }
    
    public func insertReminder(reminder: Reminder) -> Bool {
        if(!IsValidReminder(reminder: reminder)){
            return false
        }
        let result = self.reminderRepository.insertReminder(reminder: reminder)
        if(!result){
            self.errorMessage = "Failed to insert reminder"
        }
        else{
            self.errorMessage = nil
        }
        return result
    }
    
    public func getReminders(){
        self.reminders = self.reminderRepository.getAllReminders()
        if(self.reminders.isEmpty){
            self.errorMessage = "No reminders found"
        }
        else{
            self.errorMessage = nil
        }
    }
    
    public func deleteReminder(reminderId : Int64){
        let result = self.reminderRepository.deleteReminder(reminderId: reminderId)
        if(!result){
            self.errorMessage = "Failed to delete reminder"
        }
        else{
            self.errorMessage = nil
        }
    }
    
    private func IsValidReminder(reminder : Reminder) -> Bool {
        if(reminder.title.isEmpty){
            self.errorMessage = "Title is required"
            return false
        }
        if(reminder.message.isEmpty){
            self.errorMessage = "Message is required"
            return false
        }
        if(reminder.frequency.isEmpty){
            self.errorMessage = "Frequency is required"
            return false
        }
        return true
    }

    
}
