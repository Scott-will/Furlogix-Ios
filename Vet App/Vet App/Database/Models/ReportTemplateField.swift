//
//  ReportTemplateField.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

struct ReportTemplateField : Decodable{
    let id : Int64
    let reportId : Int64
    let name : String
    let favourite : Bool
    let fieldType : FieldType
}
