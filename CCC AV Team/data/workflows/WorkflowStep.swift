//
//  WorkflowStep.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation

struct WorkflowStep: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var createdTime: String = "\(Date.now)"
    var fields: Fields = Fields()
    
    struct Fields: Codable, Hashable {
        var tsOptions: [String]?
        var index: Int = 0
        var prompt: String = ""
        var sensitiveData: String?
        var imageFileName: String?
        var parentWorkflow: [String] = []
    }
}
