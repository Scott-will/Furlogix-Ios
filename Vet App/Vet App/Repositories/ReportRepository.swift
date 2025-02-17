//
//  ReportRepository.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-17.
//

class ReportRepository : ReportRepositoryProtocol{
    
    public func getReportsForPet(petId: Int64) -> [Report] {
        return ReportStore.instance.GetReportsForPet(pet_id: petId)
        
    }
    
    public func insertReport(report: Report) -> Int64? {
        return ReportStore.instance.insert(report: report)
    }
}
