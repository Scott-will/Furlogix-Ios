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
    
    private var notificationService: UserNotificationServiceProtocol
    
    @Published var reminders: [Reminder] = []
    @Published var permissionGranted = false
    
    init(remindersRepository : ReminderRepositoryProtocol = DIContainer.shared.resolve(type: ReminderRepositoryProtocol.self)!,
         userNotificationService : UserNotificationServiceProtocol = DIContainer.shared.resolve(type: UserNotificationServiceProtocol.self)!) {
        self.reminderRepository = remindersRepository
        self.notificationService = userNotificationService
    }
    
    public func insertReminder(reminder: Reminder) {
        guard IsValidReminder(reminder: reminder) else {
            self.errorMessage = "Invalid reminder"
            return
        }

        let insertResult = self.reminderRepository.insertReminder(reminder: reminder)
        if (insertResult == -1) {
            self.errorMessage = "Failed to insert reminder"
            return
        }

        self.notificationService.scheduleReminderNotification(reminder: reminder) { success in
            if !success {
                self.reminderRepository.deleteReminder(reminderId: reminder.id)
                self.errorMessage = "Failed to schedule reminder notification"
            } else {
                self.errorMessage = nil
            }
        }
    }

    
    public func getReminders() -> Bool{
        self.reminders = self.reminderRepository.getAllReminders()
        if(self.reminders.isEmpty){
            self.errorMessage = "No reminders found"
            return false
        }
        else{
            self.errorMessage = nil
        }
        return true
    }
    
    public func deleteReminder(reminder : Reminder) -> Bool{
        let result = self.reminderRepository.deleteReminder(reminderId: reminder.id)
        if(!result){
            self.errorMessage = "Failed to delete reminder"
        }
        else{
            self.notificationService.cancelReminderNotificationService(reminderRequestId: reminder.requestId)
            self.errorMessage = nil
        }
        return result
    }
    
    public func requestPermissions() {
        self.notificationService.requestNotificationPermission { result in
            if !result {
                self.errorMessage = "Permissions denied"
            } else {
                self.errorMessage = nil
            }
            self.permissionGranted = result
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
