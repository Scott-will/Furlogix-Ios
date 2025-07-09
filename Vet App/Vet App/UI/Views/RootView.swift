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
                                    ManageReportsScreenView(onNavigate: {r in routeManager.onNavigate(r)}, petId : petId)
                                case .reports(let petId):
                                    ReportsScreenView()
                                case .addPet(let userId):
                                    AddPetScreenView()
                                case .uploadPetPhoto:
                                    UploadPetPhotoScreenView()
                                case .reminders:
                                    RemindersScreenView()
                                case .reportEntryHistory(let reportId):
                                    ReportEntryHistoryScreenView(reportId: reportId)
                                case .pets(let userId):
                                    PetsScreenView()
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
            DashbaordScreenView(onNavigate: { r in routeManager.onNavigate(r) })
        } else {
            EmptyView()
        }
    }
}
