//
//  Reminders.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//
struct Reminder: Decodable {
    let id: Int64
    var frequency: String
    var startTime: String
    var title: String
    var message: String
    var requestId : String
}
