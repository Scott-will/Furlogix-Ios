//
//  EmailValidator.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

import Foundation

class EmailValidator {
    static func validateEmail(_ email: String) -> Bool {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        
        let emailFormat = "(?:[a-zA-Z0-9._%+-]+)@(?:[a-zA-Z0-9.-]+)\\.(?:[a-zA-Z]{2,64})"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}

