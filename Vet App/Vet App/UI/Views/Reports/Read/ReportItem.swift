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
    @State private var showMenu = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Use plain container with tap gesture instead of Button
            VStack(spacing: 8) {
                Text(data.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.3)) // ClickableItemRed
                    .shadow(radius: 8)
            )
            .onTapGesture {
                onClick(data)
            }

            Menu {
                Button {
                    onEditClick(data)
                } label: {
                    Label("Edit Report", systemImage: "pencil")
                }
                
                Button {
                    showDeleteWarning = true
                } label: {
                    Label("Delete Report", systemImage: "trash")
                }
                
                Button {
                    onSendClick(data)
                } label: {
                    Label("Send Report", systemImage: "envelope")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .foregroundColor(.black)
                    .padding()
            }
        }
        // Alert outside of tap area
        .alert("Are you sure?", isPresented: $showDeleteWarning) {
            Button("Delete", role: .destructive) {
                onDeleteClick(data)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Deleting this report will delete all associated templates and data")
        }
        .frame(maxWidth: .infinity)
    }
}
