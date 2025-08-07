//
//  ReminderViewModelTest.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

import Testing
@testable import Furlogix

struct ReminderViewModelTest{
    @Test
    func getReminders_Success(){
        let mockRepo = MockReminderRepository()
        let reminder = Reminder(id: 1, frequency: "abcd", startTime: "abcd", title: "abcd", message: "abcd", requestId: "abcd")
        let reminder2 = Reminder(id: 2, frequency: "abcde", startTime: "abcde", title: "abcde", message: "abcde", requestId: "abcd")
        mockRepo.fakeReminders = [reminder, reminder2]
        let vm = ReminderViewModel(remindersRepository: mockRepo)
        let result = vm.getReminders()
        #expect(result == true)
        #expect(vm.errorMessage == nil)
        #expect(vm.reminders.count == 2)
    }
    
    @Test
    func getReminders_Fails_HandlesError(){
        let mockRepo = MockReminderRepository()
        let vm = ReminderViewModel(remindersRepository: mockRepo)
        let result = vm.getReminders()
        #expect(result == false)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func insertReminder_Fails_HandlesError(){
        let mockRepo = MockReminderRepository()
        mockRepo.insertShouldReturnNil = true
        let reminder = Reminder(id: 1, frequency: "abcd", startTime: "abcd", title: "abcd", message: "abcd", requestId: "abcd")
        let vm = ReminderViewModel(remindersRepository: mockRepo)
        vm.insertReminder(reminder: reminder)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func insertReminder_InvalidReminder_MissingTitle_Fails(){
        let mockRepo = MockReminderRepository()
        let reminder = Reminder(id: 1, frequency: "abcd", startTime: "abcd", title: "", message: "abcd", requestId: "abcd")
        let vm = ReminderViewModel(remindersRepository: mockRepo)
        vm.insertReminder(reminder: reminder)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func insertReminder_InvalidReminder_MissingMessageFails(){
        let mockRepo = MockReminderRepository()
        let reminder = Reminder(id: 1, frequency: "abcd", startTime: "abcd", title: "abcd", message: "", requestId: "abcd")
        let vm = ReminderViewModel(remindersRepository: mockRepo)
        vm.insertReminder(reminder: reminder)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func insertReminder_InvalidReminder_MissingFrequency_Fails(){
        let mockRepo = MockReminderRepository()
        let reminder = Reminder(id: 1, frequency: "", startTime: "abcd", title: "abcd", message: "abcd", requestId: "abcd")
        let vm = ReminderViewModel(remindersRepository: mockRepo)
        vm.insertReminder(reminder: reminder)
        #expect(vm.errorMessage != nil)
    }
    
    @Test
    func deleteReminder_Success(){
        let mockRepo = MockReminderRepository()
        let reminder = Reminder(id: 1, frequency: "", startTime: "abcd", title: "abcd", message: "abcd", requestId: "abcd")

        let vm = ReminderViewModel(remindersRepository: mockRepo)
        let result = vm.deleteReminder(reminder: reminder)
        
        #expect(result == true)
        #expect(vm.errorMessage == nil)
    }
    
    @Test
    func deleteReminder_Fails_HandlesError(){
        let mockRepo = MockReminderRepository()
        mockRepo.deleteShouldReturnFalse = true
        let reminder = Reminder(id: 1, frequency: "", startTime: "abcd", title: "abcd", message: "abcd", requestId: "abcd")

        let vm = ReminderViewModel(remindersRepository: mockRepo)
        
        let result = vm.deleteReminder(reminder: reminder)
        
        #expect(result == false)
        #expect(vm.errorMessage != nil)
    }
}
