//
//  QuickFix.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation

struct QuickFix: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var createdTime: String = "\(Date.now)"
    var fields: Fields = Fields()
    
    struct Fields: Codable, Hashable {
        var index: Int = 0
        var description: String = ""
        var solution: String = ""
        var avCategory: [String]? = []
        var title: String = ""
        var related: [String]? = []
    }
}

