//
//  ImageSize.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation

// Raw values are the directory name in Azure
enum ImageSize: String, Codable, CaseIterable, Hashable {
    case Small
    case Medium
    case Large
}

enum ImageAspectRatio: String, CaseIterable, Codable, Hashable {
    case wide = "Wide (16x9)"
    case standard = "Standard (4x3)"
}
