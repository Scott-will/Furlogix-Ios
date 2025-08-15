//
//  ReportEntryHistoryView.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-16.
//
import SwiftUI

struct ReportEntryHistoryScreenView: View {
  let reportId: Int64
  var onNavigate: (AppRoute) -> Void
  @StateObject private var reportViewModel = ReportViewModel()
  @StateObject private var reportTemplateViewModel = ReportTemplateViewModel()
  @State private var showLoading = true

  var body: some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 16)

      // Button Row
      HStack(spacing: 16) {
        Button(action: {
          onNavigate(.reportEntry(reportId: reportId))
        }) {
          Text("Add Data")
            .font(.system(size: 18))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .padding(.top, 8)

        Button(action: {
          if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootVC = scene.windows.first?.rootViewController
          {
            reportViewModel.sendReport(id: reportId, presentingController: rootVC)
          }
        }) {
          Text("Send Reports")
            .font(.system(size: 18))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .padding(.top, 8)
      }
      .padding(.horizontal, 16)

      Spacer()
        .frame(height: 10)
        .frame(maxWidth: .infinity)

      // Content Area
      if reportViewModel.reportsForPet.isEmpty && showLoading {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .progressViewStyle(CircularProgressViewStyle())
      } else {
        ReportHistoryTable(groupedEntries: groupedEntries)
      }
    }
    .onAppear {
      Task {
        reportViewModel.loadCurrentReport(reportId: reportId)
        reportTemplateViewModel.GetReportTemplateForReport(reportId: reportId)

        // Populate report entries for each template
        for template in reportTemplateViewModel.templatesForReports {
          reportViewModel.loadReportEntries(reportTemplateId: template.id)
        }

        try? await Task.sleep(nanoseconds: 3_000_000_000)  // 3 seconds delay
        showLoading = false
      }
    }
  }

  // Computed property to group entries by timestamp
  private var groupedEntries: [String: [ReportEntry]] {
    let allEntries = reportViewModel.reportEntires.values.flatMap { $0 }
    return Dictionary(grouping: allEntries) { $0.timestamp }
  }
}

/*struct LastSentTimeDisplay: View {
    let currentReport: Report

    var body: some View {
        if let lastSent = currentReport.lastSentTime, !lastSent.isEmpty {
            HStack(alignment: .center) {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .frame(width: 16, height: 16)

                Spacer()
                    .frame(width: 4)

                Text("Last sent: \(lastSent)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .italic()
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
        }
    }
}*/
