//
//  RemindersView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//

import SwiftUI

import SwiftUI
import UserNotifications

struct RemindersScreenView: View {
    @StateObject private var viewModel = ReminderViewModel()
    @State private var addReminder = false
    @State private var headerScale: CGFloat = 0.0
    @State private var isPermissionGranted = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.97, green: 0.98, blue: 1.0),
                        Color(red: 0.93, green: 0.95, blue: 1.0),
                        Color(red: 0.88, green: 0.91, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Header Section
                        headerSection
                        
                        // Clock Illustration Card
                        clockIllustrationCard
                        
                        // Permission Status or Reminders List
                        if !isPermissionGranted {
                            permissionRequiredCard
                        } else {
                            remindersListCard
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .padding(.bottom, isPermissionGranted ? 100 : 0) // Extra bottom padding for FAB
                }
                
                // Modern Floating Action Button (only show if permission granted)
                if isPermissionGranted {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                addReminder = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(Color(red: 0.26, green: 0.91, blue: 0.48))
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 4)
                            }
                            .padding(24)
                        }
                    }
                }
            }
        }
        .onAppear {
            checkNotificationPermission()
            viewModel.getReminders()
            
            withAnimation(.easeInOut(duration: 1.0)) {
                headerScale = 1.0
            }
        }
        .sheet(isPresented: $addReminder) {
            AddReminderDialogView(
                viewModel: viewModel,
                onDismiss: {
                    addReminder = false
                    viewModel.getReminders()
                }
            )
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Reminders")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                .multilineTextAlignment(.center)
                .scaleEffect(headerScale)
            
            Text("Stay on top of your pet's care schedule")
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var clockIllustrationCard: some View {
        VStack {
            ZStack {
                // Background circle for the clock
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.26, green: 0.91, blue: 0.48).opacity(0.1),
                                Color(red: 0.22, green: 0.98, blue: 0.84).opacity(0.05)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                
                // Clock icon (using SF Symbol since we don't have the custom image)
                Image(systemName: "clock.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.26, green: 0.91, blue: 0.48))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
    }
    
    private var permissionRequiredCard: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(Color(red: 0.96, green: 0.62, blue: 0.04))
            
            VStack(spacing: 8) {
                Text("Permission Required")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.85, green: 0.47, blue: 0.02))
                    .multilineTextAlignment(.center)
                
                Text("To set up reminders, we need permission to send notifications")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.71, green: 0.33, blue: 0.04))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                requestNotificationPermission()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "gear")
                        .font(.system(size: 20))
                    Text("Enable Permissions")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(red: 0.96, green: 0.62, blue: 0.04))
                .cornerRadius(16)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(red: 1.0, green: 0.95, blue: 0.78))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
    
    private var remindersListCard: some View {
        VStack(spacing: 0) {
            if viewModel.reminders.isEmpty {
                emptyRemindersState
            } else {
                remindersContent
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
    }
    
    private var emptyRemindersState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell")
                .font(.system(size: 64))
                .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.72))
            
            VStack(spacing: 4) {
                Text("No Reminders Set")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
                
                Text("Create your first reminder to stay on track")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.72))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private var remindersContent: some View {
        VStack(spacing: 16) {
            // Reminders header
            HStack {
                Text("Your Reminders")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                
                Spacer()
                
                Text("\(viewModel.reminders.count) Active")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.02, green: 0.59, blue: 0.41))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.26, green: 0.91, blue: 0.48).opacity(0.1))
                    .cornerRadius(12)
            }
            
            // Reminders list
            RemindersListView(
                reminders: viewModel.reminders,
                onDeleteClick: { reminder in
                    viewModel.deleteReminder(reminder: reminder)
                    viewModel.getReminders()
                }
            )
        }
    }
    
    private func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isPermissionGranted = settings.authorizationStatus == .authorized
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isPermissionGranted = granted
            }
        }
    }
}

struct RemindersListView: View {
    let reminders: [Reminder]
    let onDeleteClick: (Reminder) -> Void
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(reminders, id: \.id) { reminder in
                ReminderRowView(
                    reminder: reminder,
                    onDeleteClick: { onDeleteClick(reminder) }
                )
            }
        }
    }
}

struct ReminderRowView: View {
    let reminder: Reminder
    let onDeleteClick: () -> Void
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Reminder icon
            Image(systemName: "bell.fill")
                .font(.system(size: 24))
                .foregroundColor(Color(red: 0.26, green: 0.91, blue: 0.48))
                .frame(width: 40, height: 40)
                .background(Color(red: 0.26, green: 0.91, blue: 0.48).opacity(0.1))
                .cornerRadius(12)
            
            // Reminder info
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(reminder.message ?? "Reminder")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.72))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Delete button
            Button(action: {
                showDeleteConfirmation = true
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(.red)
                    .frame(width: 32, height: 32)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
        .alert("Delete Reminder", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDeleteClick()
            }
        } message: {
            Text("Are you sure you want to delete this reminder?")
        }
    }
}

struct AddReminderDialogView: View {
    let viewModel: ReminderViewModel
    let onDismiss: () -> Void
    @State private var reminderTitle = ""
    @State private var reminderText = ""
    @State private var selectedDateTime = Date()
    @State private var recurrenceOption = "Once"
    @State private var showingRecurrencePicker = false
    
    let recurrenceOptions = ["Once", "Daily", "Weekly", "Monthly"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Schedule a Reminder")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                    
                    TextField("Enter title", text: $reminderTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Message")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                    
                    TextField("Enter message", text: $reminderText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Frequency")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                    
                    Button(action: {
                        showingRecurrencePicker = true
                    }) {
                        HStack {
                            Text(recurrenceOption)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date & Time")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                    
                    DatePicker(
                        "Select Date & Time",
                        selection: $selectedDateTime,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                }
                
                Spacer()
                
                Button(action: {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .short
                    let startTimeString = formatter.string(from: selectedDateTime)
                    var reminder = Reminder(id: -1,
                                            frequency: recurrenceOption,
                                            startTime: startTimeString,
                                            title: reminderTitle,
                                            message: reminderText,
                                            requestId: UUID().uuidString)
                    viewModel.insertReminder(reminder: reminder);
                    onDismiss()
                }) {
                    Text("Schedule Reminder")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.26, green: 0.91, blue: 0.48))
                        .cornerRadius(12)
                }
                .disabled(reminderTitle.isEmpty)
            }
            .padding(20)
            .navigationTitle("")
            .navigationBarHidden(true)
            .actionSheet(isPresented: $showingRecurrencePicker) {
                ActionSheet(
                    title: Text("Select Frequency"),
                    buttons: recurrenceOptions.map { option in
                            .default(Text(option)) {
                                recurrenceOption = option
                            }
                    } + [.cancel()]
                )
            }
        }
    }
    
}
