//
//  RootView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-04.
//
import SwiftUI

struct RootView: View {
    @StateObject var userViewModel = UserViewModel()
    @StateObject private var routeManager = RouteManager.shared


    var body: some View {

            NavigationStack(path: $routeManager.path) {
                VStack(spacing: 0) {
                AppHeader()
                .frame(height: 60)
                .background(Themes.primaryColor)
                contentView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .dashboard(let userId):
                            DashbaordScreenView(onNavigate: {r in routeManager.onNavigate(r)})
                        case .reportsTemplate(let reportId, let reportName):
                            ReportTemplateScreenView()
                        case .petDashboard(let petId):
                            PetDashbaordScreenView(petId: petId, onNavigate: {r in routeManager.onNavigate(r)})
                        case .profile(let userId):
                            ProfileScreenView()
                        case .reportEntry(let reportId):
                            ReportEntryScreenView()
                        case .manageReports(let petId):
                            ManageReportsScreenView(petId : petId)
                        case .reports(let petId):
                            ReportsScreenView()
                        case .addPet(let userId):
                            AddPetScreenView()
                        case .uploadPetPhoto:
                            UploadPetPhotoScreenView()
                        case .reminders:
                            RemindersScreenView()
                        case .reportEntryHistory(let reportId):
                            ReportEntryHistoryScreenView()
                        case .pets(let userId):
                            PetsScreenView()
                        case .editReport:
                            EditReportScreenView()
                        default:
                            Text("Unknown route")
                        }
                    }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    

    @ViewBuilder
        private func contentView() -> some View {
            if routeManager.path.isEmpty {
                DashbaordScreenView(onNavigate: {r in routeManager.onNavigate(r)})
            } else {
                EmptyView()
            }
        }
}
