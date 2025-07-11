//
//  ReportViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//
import Foundation
import MessageUI

class ReportViewModel : ObservableObject, ErrorMessageProvider{
    @Published var errorMessage : String? = nil

    @Published var reportsForPet : [Report] = []
    
    @Published var currentReport : Report? = nil
    
    private let reportRepository : ReportRepositoryProtocol
    
    
    init(reportRepository : ReportRepositoryProtocol = DIContainer.shared.resolve(type: ReportRepositoryProtocol.self)!){
        self.reportRepository = reportRepository
    }
    
    public func GetReportsForPet(petId : Int64){
        self.reportsForPet = self.reportRepository.getReportsForPet(petId: petId)
        if(self.reportsForPet.isEmpty){
            errorMessage = "No reports found for this pet."
        }
        else{
            errorMessage = nil
        }
    }
    
    public func insertReport(name : String, petId : Int64) -> Int64?{
        let report = Report(id : -1, name: name, petId: petId)
        if(!IsReportValid(report)){
            self.errorMessage = "Report name must not be empty."
            return -1
        }
        let result = self.reportRepository.insertReport(report: report)
        if(result == -1){
            self.errorMessage = "Failed to insert report"
        }else{
            self.errorMessage = nil
        }
        return result
    }
    
    public func deleteReport(id : Int64) -> Bool{
        let result = self.reportRepository.DeleteReport(reportId: id)
        if(!result){
            self.errorMessage = "Failed to delete report"
        }
        else{
            self.errorMessage = nil
        }
        return result;
    }
    
    public func sendReport(id: Int64, presentingController: UIViewController) {
            let emailService = EmailService()
            Task {
                await emailService.gatherReportData(reportId: id, presentingController: presentingController)
            }
        }
    
    public func loadCurrentReport(reportId : Int64){
        self.currentReport = self.reportsForPet.first{ $0.id == reportId}
    }
    
    private func IsReportValid(_ report : Report) -> Bool{
        if report.name.isEmpty{
            return false
        }
        return true
    }
}
