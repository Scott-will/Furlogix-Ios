//
//  ReportHistoryTableView.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-05.
//
import SwiftUI

struct ReportHistoryTable: View {
    let groupedEntries: [String: [ReportEntry]]
    
    private var itemIds: [Int64] {
        groupedEntries.values.flatMap(\.self).map(\.id).uniqued().sorted()
    }

    
    private var timestamps: [String] {
        groupedEntries.keys.sorted()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    Section {
                        ForEach(timestamps.indices, id: \.self) { index in
                            let timestamp = timestamps[index]
                            let entries = groupedEntries[timestamp] ?? []
                            ReportHistoryRow(
                                timestamp: timestamp,
                                entries: entries,
                                itemIds: itemIds,
                                isEven: index.isMultiple(of: 2),
                                isLast: index == timestamps.count - 1
                            )
                        }
                    } header: {
                        ReportHistoryHeader(itemIds: itemIds)
                    }
                }
            }
        }
        .background(Color(red: 0.980, green: 0.980, blue: 0.980))
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}




private struct ReportHistoryHeader: View {
    let itemIds: [Int64]
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("Timestamp")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .kerning(0.5)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
            
            ForEach(itemIds, id: \.self) { itemId in
                Text("Item \(itemId)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .kerning(0.5)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(Color(red: 0.980, green: 0.980, blue: 0.980))
    }
}

private struct ReportHistoryRow: View {
    let timestamp: String
    let entries: [ReportEntry]
    let itemIds: [Int64]
    let isEven: Bool
    let isLast: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                ReportHistoryCell(text: timestamp, isHeader: true)
                
                ForEach(itemIds, id: \.self) { id in
                    let entry = entries.first { $0.id == id }
                    ReportHistoryCell(text: entry?.value ?? "")
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(isEven ? Color.white : Color(red: 0.976, green: 0.980, blue: 0.984))
            
            if !isLast {
                Divider()
                    .background(Color(red: 0.953, green: 0.957, blue: 0.965))
                    .frame(height: 1)
                    .padding(.horizontal, 20)
            }
        }
    }
}

private struct ReportHistoryCell: View {
    let text: String
    var isHeader: Bool = false
    
    var body: some View {
        Text(text.isEmpty ? "—" : text)
            .font(.system(size: isHeader ? 15 : 14, weight: isHeader ? .semibold : (text.isEmpty ? .regular : .medium)))
            .foregroundColor(isHeader
                             ? Color(red: 0.122, green: 0.161, blue: 0.216)
                             : (text.isEmpty
                                ? Color(red: 0.820, green: 0.835, blue: 0.863)
                                : Color(red: 0.216, green: 0.255, blue: 0.318)))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
    }
}

// Extension to get unique elements from array
extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

