//
//  ReportItem.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-08.
//

import SwiftUI

struct ReportItem: View {
    let data: Report
    let onClick: (Report) -> Void
    let onEditClick: (Report) -> Void
    let onDeleteClick: (Report) -> Void
    let onSendClick: (Report) -> Void
    
    @State private var showDeleteWarning = false
    @State private var showActionSheet = false
    
    var body: some View {
        Button(action: {
            onClick(data)
        }) {
            ZStack {
                // Card background
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                
                // Gradient overlay
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.05),
                                Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                HStack(spacing: 16) {
                    // Report icon
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.1))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                    }
                    
                    // Report info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(data.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
                            
                            Text("Tap to view details")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
                        }
                        
                        Spacer()
                    }
                    
                    // More options button
                    Button(action: {
                        showActionSheet = true
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
                            .frame(width: 36, height: 36)
                            .background(Color(red: 0.58, green: 0.64, blue: 0.72).opacity(0.1))
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(20)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Report Actions"),
                message: Text("Choose an action for this report"),
                buttons: [
                    .default(Text("Edit Report")) {
                        onEditClick(data)
                    },
                    .default(Text("Send Report")) {
                        onSendClick(data)
                    },
                    .destructive(Text("Delete Report")) {
                        showDeleteWarning = true
                    },
                    .cancel()
                ]
            )
        }
        .alert("Delete Report", isPresented: $showDeleteWarning) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDeleteClick(data)
            }
        } message: {
            Text("Deleting this report will delete all associated templates and data")
        }
    }
}

struct ReportsListView: View {
    let dataList: [Report]
    let onSendClick: (Report) -> Void
    let onDeleteClick: (Report) -> Void
    let onEditClick: (Report) -> Void
    let onClick: (Report) -> Void
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(dataList, id: \.id) { data in
                ReportItemWithMenu(
                    data: data,
                    onClick: onClick,
                    onEditClick: onEditClick,
                    onDeleteClick: onDeleteClick,
                    onSendClick: onSendClick
                )
            }
        }
    }
}

// Alternative implementation using Menu for iOS 14+ (more native approach)
struct ReportItemWithMenu: View {
    let data: Report
    let onClick: (Report) -> Void
    let onEditClick: (Report) -> Void
    let onDeleteClick: (Report) -> Void
    let onSendClick: (Report) -> Void
    
    @State private var showDeleteWarning = false
    
    var body: some View {
        Button(action: {
            onClick(data)
        }) {
            ZStack {
                // Card background
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                
                // Gradient overlay
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.05),
                                Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                HStack(spacing: 16) {
                    // Report icon
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.1))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                    }
                    
                    // Report info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(data.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
                            
                            Text("Tap to view details")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
                        }
                        
                        Spacer()
                    }
                    
                    // More options menu (iOS 14+ approach)
                    Menu {
                        Button(action: {
                            onEditClick(data)
                        }) {
                            Label("Edit Report", systemImage: "pencil")
                        }
                        
                        Button(action: {
                            onSendClick(data)
                        }) {
                            Label("Send Report", systemImage: "paperplane")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive, action: {
                            showDeleteWarning = true
                        }) {
                            Label("Delete Report", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.39, green: 0.46, blue: 0.55))
                            .frame(width: 36, height: 36)
                            .background(Color(red: 0.58, green: 0.64, blue: 0.72).opacity(0.1))
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(20)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Delete Report", isPresented: $showDeleteWarning) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDeleteClick(data)
            }
        } message: {
            Text("Deleting this report will delete all associated templates and data")
        }
    }
}
