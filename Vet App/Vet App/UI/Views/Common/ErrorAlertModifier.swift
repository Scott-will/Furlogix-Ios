//
//  ErrorAlertModifier.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-07.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    var viewModels: [any ErrorMessageProvider]
    @State private var showErrorAlert = false

    func body(content: Content) -> some View {
        content
            .onChange(of: combinedErrorMessage(), initial: false) { newValue, arg in
                if newValue != nil {
                    showErrorAlert = true
                }
            }
            .alert("Error", isPresented: $showErrorAlert, actions: {
                Button("OK") {
                    clearAllErrors()
                }
            }, message: {
                Text(combinedErrorMessage() ?? "Unknown error")
            })
    }

    private func combinedErrorMessage() -> String? {
        for vm in viewModels {
            if let msg = vm.errorMessage {
                return msg
            }
        }
        return nil
    }

    private func clearAllErrors() {
        for vm in viewModels {
            vm.errorMessage = nil
        }
    }
}
