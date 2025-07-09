//
//  Logger.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-07.
//

import Foundation
import os

struct AppLogger{
    static let subsystem = Bundle.main.bundleIdentifier ?? "Furlogix"

    static let general = Logger(subsystem: subsystem, category: "General")
    
    static func info(_ message: String) {
            general.info("\(message, privacy: .public)")
        }

        static func debug(_ message: String) {
            general.debug("\(message, privacy: .public)")
        }

        static func error(_ message: String) {
            general.error("\(message, privacy: .public)")
        }


}
