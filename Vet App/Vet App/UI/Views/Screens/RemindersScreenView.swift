//
//  RemindersView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//

import SwiftUI

struct RemindersScreenView : View{
    @ObservedObject var remindersViewModel = ReminderViewModel()
    @State private var showAddReminder = false

    
    var body : some View{
            VStack{
                Text("Reminders Screen")
                List(remindersViewModel.reminders, id: \.id){
                    item in
                    ReminderItem(data: item, onDeleteClick: {item in remindersViewModel.deleteReminder(reminderId: item.id)})
                }
                Button(action: {
                    showAddReminder = true
                }){
                    Text("Add Reminder")
                }.buttonStyle(AppButtonStyle())
            }.onAppear{
                remindersViewModel.getReminders()
            }.sheet(isPresented: $showAddReminder) {
                ReportsReminder()
            }
        
    }
}
