//
//  Reminders.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//
struct Reminder: Decodable {
    let id: Int
    var frequency: String
    var type: String
    var startTime: String
    var title: String
    var message: String
}
