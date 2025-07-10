//
//  ReportEntry.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

struct ReportEntry : Decodable, Identifiable{
    let id : Int64
    let value : String
    let reportId : Int64
    let templateId : Int64
    let timestamp : String
    let sent : Bool
}
