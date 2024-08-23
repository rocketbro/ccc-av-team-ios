//
//  Logger.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import os.log

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

struct Logger {
    static let shared = Logger()
    
    private init() {}
    
    func log(_ message: String, level: LogLevel = .info) {
        let logMessage = "[\(level.rawValue)] \(message)"
        switch level {
        case .debug, .info:
            os_log("%{PUBLIC}@", log: .default, type: .info, logMessage)
        case .warning:
            os_log("%{PUBLIC}@", log: .default, type: .default, logMessage)
        case .error:
            os_log("%{PUBLIC}@", log: .default, type: .error, logMessage)
        }
    }
}
