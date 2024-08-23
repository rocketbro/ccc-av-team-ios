//
//  ImageSize.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation

// Raw values are the directory name in Azure
enum ImageSize: String {
    case Small
    case Medium
    case Large
}

let globalImageSize: ImageSize = .Medium
