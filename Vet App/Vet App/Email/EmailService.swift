//
//  EmailService.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

import MessageUI

class EmailService{
    
    private let reportRepository : ReportRepositoryProtocol

    private let reportTemplateRepository: ReportTemplateRepositoryProtocol
    
    private let reportEntryRepository: ReportEntryRepositoryProtocol
    
    private let userRepository: UserRepositoryProtocol
    
    init(reportRepository : ReportRepositoryProtocol = DIContainer.shared.resolve(type: ReportRepositoryProtocol.self)!,
         reportTemplateRepository: ReportTemplateRepositoryProtocol = DIContainer.shared.resolve(type: ReportTemplateRepositoryProtocol.self)!,
         reportEntryRepository: ReportEntryRepositoryProtocol = DIContainer.shared.resolve(type: ReportEntryRepositoryProtocol.self)!,
         userRepository: UserRepositoryProtocol = DIContainer.shared.resolve(type: UserRepositoryProtocol.self)!){
        self.reportRepository = reportRepository
        self.reportEntryRepository = reportEntryRepository
        self.reportTemplateRepository = reportTemplateRepository
        self.userRepository = userRepository
    }
    
    func gatherReportData(reportId: Int64, presentingController: UIViewController) async {
        print("Gathering report data to send in email")
        
        let report = reportRepository.GetReportById(reportId: reportId)
        if(report == nil){
            return
        }
        let reportName = report?.name ?? ""
        let templates = reportTemplateRepository.GetTemplatesForReport(reportId: reportId)
        var entries = reportEntryRepository.GetAllEntriesForReport(reportId: reportId)
        if(entries == nil){
            return
        }
        
        // Build CSV file
        let csvBuilder = CsvBuilder()
        guard let fileURL = csvBuilder.buildAndWriteCsv(reportName: reportName, entries: entries!, templates: templates) else {
            //updateErrorState(show: true, message: "Failed to create CSV file")
            return
        }
        
        // Get user email
        let email = userRepository.getCurrentUser()?.email ?? ""
        
        // Create email wrapper
        let emailWrapper = EmailWrapper(
            toEmailAddress: email,
            subject: "Pet Reports",
            bodyText: "\(reportName)_\(Date().formatted())",
            fileURL: fileURL
        )
        
        // Send email
        let emailHandler = EmailHandler(userRepository: userRepository)
        emailHandler.createAndSendEmail(wrapper: emailWrapper, presentingController: presentingController)
        
        // Update entries
        for i in entries!.indices {
            entries![i].sent = true
        }
        
        // Update report last sent time
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //report.lastSentTime = formatter.string(from: Date())
        reportRepository.UpdateReport(report: report!)
        
        /*if !entries.isEmpty {
            try await reportEntryRepository.updateReportEntries(entries: entries)
        }*/
    }
}
