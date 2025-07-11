//
//  ViewExtension.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-07.
//

import SwiftUI

extension View {
    func withErrorAlerts(viewModels: [any ErrorMessageProvider]) -> some View {
        self.modifier(ErrorAlertModifier(viewModels: viewModels))
    }
}
