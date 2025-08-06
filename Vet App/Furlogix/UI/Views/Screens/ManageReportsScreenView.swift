//
//  ManageReportsView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//

import SwiftUI

import SwiftUI

struct ManageReportsScreenView: View {
    let petId: Int64
    var onNavigate: (AppRoute) -> Void
    @StateObject private var petViewModel = PetViewModel()
    @StateObject private var reportViewModel = ReportViewModel()
    @State private var showDialog = false
    @State private var label = ""
    @State private var headerScale: CGFloat = 0.0
    
    
    private var filteredReports: [Report] {
        reportViewModel.reportsForPet.filter { $0.petId == petId }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundGradient()
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        HeaderSection(title: "\(petViewModel.currentpet?.name ?? "Pet") Reports", subtitle: "Track and manage health reports")
                        
                        // Too Many Reports Warning Card
                      /*  if reportViewModel. {
                            tooManyReportsCard
                        }
                        */
                        reportsListCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .padding(.bottom, 100) 
                }
                FloatingActionButton(onClick: {showDialog = true})
            }
        }
        .onAppear {
            petViewModel.GetPetById(petId: petId)
            reportViewModel.GetReportsForPet(petId: petId)
            
            withAnimation(.easeInOut(duration: 1.0)) {
                headerScale = 1.0
            }
        }
        .sheet(isPresented: $showDialog) {
            AddReportDialogView(
                currentLabel: $label,
                onSave: { newItem in
                    reportViewModel.insertReport(name: newItem.name, petId: petId)
                    label = ""
                    showDialog = false
                },
                onDismiss: {
                    showDialog = false
                }
            )
        }
        .alert("Error", isPresented: .constant((reportViewModel.errorMessage != nil))) {
            Button("OK") {
                //reportViewModel.(isError: false, message: "")
            }
        } message: {
            Text(reportViewModel.errorMessage ?? "Unknown error")
        }
    }
    
    private var tooManyReportsCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(Color(red: 0.94, green: 0.27, blue: 0.27))
            
            Text("Too Many Reports")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(red: 0.86, green: 0.15, blue: 0.15))
                .multilineTextAlignment(.center)
            
            Text("You have reached the maximum number of reports")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.6, green: 0.11, blue: 0.11))
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 4)
            
            Button(action: {
                //reportViewModel.deleteSentReports()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                        .font(.system(size: 18))
                    Text("Delete Sent Reports")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.94, green: 0.27, blue: 0.27))
                .cornerRadius(16)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(red: 1.0, green: 0.95, blue: 0.95))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
    
    private var reportsListCard: some View {
        VStack(spacing: 0) {
            if filteredReports.isEmpty {
                emptyReportsState
            } else {
                reportsContent
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
    }
    
    private var emptyReportsState: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar")
                .font(.system(size: 64))
                .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.72))
            
            VStack(spacing: 4) {
                Text("No Reports Yet")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
                
                Text("Create your first health report")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.72))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private var reportsContent: some View {
        VStack(spacing: 16) {
            // Reports header
            HStack {
                Text("Health Reports")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                
                Spacer()
                
                Text("\(filteredReports.count) \(filteredReports.count == 1 ? "Report" : "Reports")")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.1))
                    .cornerRadius(12)
            }
            
            // Reports list
            ReportsListView(
                dataList: filteredReports,
                onSendClick: { report in
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootVC = scene.windows.first?.rootViewController {
                        reportViewModel.sendReport(id: report.id, presentingController: rootVC)
                    }
                },
                onDeleteClick: { report in
                    reportViewModel.deleteReport(id: report.id)
                },
                onEditClick: { report in
                    onNavigate(.editReport(reportId: report.id))
                },
                onClick: { report in
                    onNavigate(.reportEntryHistory(reportId: report.id))
                }
            )
        }
    }
}
