//
//  ErrorMessageProvider.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-07.
//

import Foundation

protocol ErrorMessageProvider: ObservableObject {
    var errorMessage: String? { get set }
}
