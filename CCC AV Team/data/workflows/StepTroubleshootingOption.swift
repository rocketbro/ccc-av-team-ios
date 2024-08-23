//
//  StepTroubleshootingOption.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation

struct TroubleshootingOption: Codable, Identifiable {
    let id: String
    let createdTime: String
    let fields: Fields
    
    struct Fields: Codable {
        let parentStep: [String]?
        let index: Int
        let prompt: String
        let solution: String
        let imageFileName: String?
    }
}

