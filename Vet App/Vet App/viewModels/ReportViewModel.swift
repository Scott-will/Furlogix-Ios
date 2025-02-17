//
//  ReportViewModel.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//
import Foundation

class ReportViewModel : ObservableObject{
    
    @Published var reportsForPet : [Report] = []
    
    private let reportRepository : ReportRepositoryProtocol
    
    init(reportRepository : ReportRepositoryProtocol = DIContainer.shared.resolve(type: ReportRepositoryProtocol.self)!){
        self.reportRepository = reportRepository
    }
    
    public func GetReportsForPet(petId : Int64){
        self.reportsForPet = self.reportRepository.getReportsForPet(petId: petId)
    }
    
    public func insertReport(name : String, petId : Int64) -> Int64?{
        let report = Report(id : -1, name: name, petId: petId)
        //TODO: handle error
        return self.reportRepository.insertReport(report: report)
    }
}
