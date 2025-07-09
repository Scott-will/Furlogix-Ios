//
//  ReportEntryViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//

import SwiftUI

class ReportEntryViewModel : ObservableObject {
    @Published var errorMsg : String? = nil
    
    private var reportEntryRepositoryProtocol : ReportEntryRepositoryProtocol
    
    
    @State var reportEntryList : [ReportEntry] = []
    
    init(reportEntryRepositoryProtocol : ReportEntryRepositoryProtocol = DIContainer.shared.resolve(type: ReportEntryRepositoryProtocol.self)!) {
        self.reportEntryRepositoryProtocol = reportEntryRepositoryProtocol
    }
    
    func loadReportEntryList(reportId : Int64) {
        AppLogger.debug("Loading report entries for report: \(reportId)")
        var result = self.reportEntryRepositoryProtocol.GetAllEntriesForReport(reportId: reportId)
        if(result == nil){
            AppLogger.error("Failed to load entries for report: \(reportId)")
            return
        }
        self.reportEntryList = result!
    }

}
