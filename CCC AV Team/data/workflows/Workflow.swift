//
//  Workflow.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation

// Define the main struct to decode the JSON
struct Workflow: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var createdTime: String = "\(Date.now)"
    var fields: Fields = Fields()
    
    // Define the nested Fields struct
    struct Fields: Codable, Hashable {
        var index: Int = 0
        var title: String = ""
        var steps: [String] = []
        var description: String = ""
        var avCategory: [String] = []
    }
}

