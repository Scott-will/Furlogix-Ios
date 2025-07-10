//
//  CsvBuilder.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

import Foundation
import UIKit

class CsvBuilder {
    
    func buildAndWriteCsv(reportName: String, entries: [ReportEntry], templates: [ReportTemplateField]) -> URL? {
        let fileName = "\(reportName)_\(Date().formatted()).csv"
        
        // Write to the app's documents directory
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent(fileName)
        
        let csvString = buildCsv(entries: entries, templates: templates)
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Failed to write CSV: \(error)")
            return nil
        }
    }
    
    func buildCsv(entries: [ReportEntry], templates: [ReportTemplateField]) -> String {
        var csv = ""
        
        let header = templates.map {
            /*if let units = $0.units, !units.isEmpty {
                "\($0.name) (\(units))"
            } else {
                $0.name
            }*/
            $0.name
        }.joined(separator: ",")
        csv += header + "\n"
        
        // Group entries by timestamp
        let grouped = Dictionary(grouping: entries, by: { $0.timestamp })
        let sortedKeys = grouped.keys.sorted()
        
        for timestamp in sortedKeys {
            guard let reportList = grouped[timestamp] else { continue }
            
            var line = ""
            for (index, template) in templates.enumerated() {
                let entry = reportList.first { $0.templateId == template.id }
                let value = entry?.value ?? ""
                line += "\"\(value)\""
                if index != templates.count - 1 {
                    line += ","
                }
            }
            csv += line + "\n"
        }
        
        return csv
    }
}
