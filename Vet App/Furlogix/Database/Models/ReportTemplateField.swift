//
//  ReportTemplateField.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

struct ReportTemplateField : Decodable{
    var id : Int64 = 0
    var reportId : Int64
    var name : String
    var fieldType : FieldType
}
