//
//  UserNotificationService.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

import UserNotifications

class UserNotificationService: UserNotificationServiceProtocol {

  func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
    AppLogger.info("Requesting notification permission")
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
      granted, error in
      if granted {
        AppLogger.info("Notification permission granted")
      } else {
        AppLogger.info("Notification permission denied")
      }
      DispatchQueue.main.async {
        completion(granted)
      }
    }
  }

  func scheduleReminderNotification(reminder: Reminder, completion: @escaping (Bool) -> Void) {
    let content = UNMutableNotificationContent()
    content.title = reminder.title
    content.body = reminder.message
    content.sound = .default

    guard let date = self.getDate(from: reminder.startTime) else {
      completion(false)
      return
    }

    let calendar = Calendar.current

    var components: DateComponents

    switch reminder.frequency.lowercased() {
    case "daily":
      components = calendar.dateComponents([.hour, .minute], from: date)
      break

    case "weekly":
      components = calendar.dateComponents([.weekday, .hour, .minute], from: date)
      break

    case "once":
      components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
      break

    default:
      print("Unsupported frequency: \(reminder.frequency)")
      completion(false)
      return
    }

    let repeats = reminder.frequency.lowercased() != "once"

    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)

    let request = UNNotificationRequest(
      identifier: reminder.requestId, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
      DispatchQueue.main.async {
        if let error = error {
          AppLogger.error("Error scheduling notification: \(error)")
          completion(false)
        } else {
          AppLogger.info("Notification scheduled for \(date)")
          completion(true)
        }
      }
    }
  }

  func cancelReminderNotificationService(reminderRequestId: String) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [
      reminderRequestId
    ])
  }

  private func getDate(from dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")  // important for AM/PM
    formatter.dateFormat = "yyyy-MM-dd, h:mm a"
    if let dateFromString = formatter.date(from: dateString) {
      return dateFromString
    } else {
      print("Failed to parse date string")
      return nil
    }
  }

}
