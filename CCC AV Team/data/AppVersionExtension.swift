//
//  AppVersionExtension.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/27/24.
//

import Foundation

extension Bundle {
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown Version"
    }

    var appBuild: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown Build"
    }
}

