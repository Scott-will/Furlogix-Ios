//
//  ReportEntry.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

struct ReportEntry : Decodable, Identifiable{
    let id : Int64
    var value : String
    var reportId : Int64
    var templateId : Int64
    var timestamp : String
    var sent : Bool
}
