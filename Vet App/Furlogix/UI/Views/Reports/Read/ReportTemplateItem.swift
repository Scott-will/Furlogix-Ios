//
//  ReportTemplateItem.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-08.
//

import SwiftUI

struct ReportTemplatesList: View {
  let templates: [ReportTemplateField]
  let onDeleteClick: (ReportTemplateField) -> Void
  let onUpdateClick: (ReportTemplateField) -> Void

  var body: some View {
    LazyVGrid(
      columns: [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
      ], spacing: 16
    ) {
      ForEach(templates) { template in
        ReportTemplateItem(
          data: template,
          onDeleteClick: onDeleteClick,
          onUpdateClick: onUpdateClick
        )
      }
    }
  }
}

struct ReportTemplateItem: View {
  let data: ReportTemplateField
  let onDeleteClick: (ReportTemplateField) -> Void
  let onUpdateClick: (ReportTemplateField) -> Void

  @State private var showDialog = false
  @State private var showDeleteWarning = false

  var body: some View {
    ZStack {
      // Background gradient
      LinearGradient(
        colors: [
          Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.05),
          Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.1),
        ],
        startPoint: .top,
        endPoint: .bottom
      )

      VStack(spacing: 0) {
        // Icon section
        VStack(spacing: 16) {
          Circle()
            .fill(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.1))
            .frame(width: 48, height: 48)
            .overlay(
              IconDisplayer(iconName: data.icon)
            )

          // Text section
          VStack(spacing: 8) {
            Text(data.name)
              .font(.system(size: 14, weight: .bold))
              .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
              .multilineTextAlignment(.center)
              .lineLimit(2)

            // Field type chip
            Text(data.fieldType.displayName)
              .font(.system(size: 10, weight: .medium))
              .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
              .padding(.horizontal, 8)
              .padding(.vertical, 4)
              .background(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.1))
              .cornerRadius(12)
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
        .padding(.horizontal, 16)

        Spacer()

        // Action buttons
        HStack(spacing: 8) {
          // Edit button
          Button(action: {
            showDialog = true
          }) {
            Image(systemName: "pencil")
              .font(.system(size: 18))
              .foregroundColor(Color(red: 0.02, green: 0.59, blue: 0.41))
              .frame(maxWidth: .infinity)
              .frame(height: 36)
              .background(Color(red: 0.02, green: 0.59, blue: 0.41).opacity(0.1))
              .cornerRadius(12)
          }
          .buttonStyle(PlainButtonStyle())

          // Delete button
          Button(action: {
            showDeleteWarning = true
          }) {
            Image(systemName: "trash")
              .font(.system(size: 18))
              .foregroundColor(Color(red: 0.94, green: 0.27, blue: 0.27))
              .frame(maxWidth: .infinity)
              .frame(height: 36)
              .background(Color(red: 0.94, green: 0.27, blue: 0.27).opacity(0.1))
              .cornerRadius(12)
          }
          .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
      }
    }
    .aspectRatio(1.0, contentMode: .fit)
    .background(Color.white)
    .cornerRadius(20)
    .shadow(radius: 8, y: 4)
    .sheet(isPresented: $showDialog) {
      AddReportTemplateDialog(
        reportId: data.reportId,
        currentLabel: data.name,
        selectedType: data.fieldType,
        currentUnit: "",
        update: true,
        reportField: data,
        onDismiss: { showDialog = false },
        onSave: { updatedItem in
          onUpdateClick(updatedItem)
          showDialog = false
        }
      )
    }
    .alert("Delete Template", isPresented: $showDeleteWarning) {
      Button("Cancel", role: .cancel) {
        showDeleteWarning = false
      }
      Button("Delete", role: .destructive) {
        onDeleteClick(data)
        showDeleteWarning = false
      }
    } message: {
      Text("Deleting this report template will delete all associated data")
    }
  }
}

struct IconDisplayer: View {
  let iconName: String

  var body: some View {
    Group {
      if !iconName.isEmpty {
        if UIImage(named: iconName) != nil {
          Image(iconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
        } else {
          Image(systemName: iconName)
            .font(.system(size: 24, weight: .medium))
            .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
        }
      } else {
        Image(systemName: "photo")
          .font(.system(size: 24, weight: .medium))
          .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.5))
      }
    }
  }
}
