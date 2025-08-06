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
        VStack{
            if(userViewModel.users.isEmpty){
                SignUpScreenView(onNavigate: { route in
                    routeManager.onNavigate(route)
                    
                })
            }
            else{
                AppHeader()
                    .frame(height: 60)
                    .background(Themes.primaryColor)
                NavigationStack(path: $routeManager.path) {
                        contentView()
                            .navigationDestination(for: AppRoute.self) { route in
                                switch route {
                                case .dashboard(let userId):
                                    DashboardScreenView(userId: 1, onNavigate: {r in routeManager.onNavigate(r)})
                               case .petDashboard(let petId):
                                    PetDashboardScreenView(petId: petId, onNavigate: {r in routeManager.onNavigate(r)})
                                case .profile(let userId):
                                    ProfileScreenView(onNavigate: {r in routeManager.onNavigate(r)}, userId: 1)
                                case .reportEntry(let reportId):
                                    ReportEntryScreenView(reportId: reportId, onNavigate: {r in routeManager.onNavigate(r)})
                                case .manageReports(let petId):
                                    ManageReportsScreenView(petId : petId, onNavigate: {r in routeManager.onNavigate(r)})
                                case .addPet(let userId):
                                    AddPetScreenView()
                                case .uploadPetPhoto:
                                    UploadPetPhotoScreenView()
                                case .reminders:
                                    RemindersScreenView()
                                case .reportEntryHistory(let reportId):
                                    ReportEntryHistoryScreenView(reportId: reportId, onNavigate: {r in routeManager.onNavigate(r)})
                                case .pets(let userId):
                                    PetsScreenView(onNavigate: {r in routeManager.onNavigate(r)}, userId: 1)
                                case .editReport(let reportId):
                                    EditReportScreenView(reportId: reportId)
                                default:
                                    Text("Unknown route")
                                }
                            }
                    
                }
                .edgesIgnoringSafeArea(.top)
            }
        }.onAppear(){
            userViewModel.getUsers()
        }
        
        
    }

    @ViewBuilder
    private func contentView() -> some View {
        if routeManager.path.isEmpty {
            DashboardScreenView(userId: 1, onNavigate: { r in routeManager.onNavigate(r) })
        } else {
            EmptyView()
        }
    }
}
