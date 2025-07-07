//
//  Routes.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-04.
//
enum AppRoute: Hashable {
    case login
    case createAccount
    case dashboard(userId: Int64)
    case petDashboard(petId: Int64)
    case profile(userId: Int64)
    case reportsTemplate(reportId: Int64, reportName: String)
    case reportEntry(reportId: Int64)
    case manageReports(petId: Int64)
    case reports(petId: Int64)
    case addPet(userId: Int64)
    case uploadPetPhoto
    case reminders
    case reportEntryHistory(reportId: Int64)
    case pets(userId: Int64)
    case editReport(reportId: Int64)
}
