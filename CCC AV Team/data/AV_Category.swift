//
//  AV_Category.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation

struct AVCategory: Codable, Identifiable, Hashable {
    var id: String
    var createdTime: String
    var fields: Fields
    
    struct Fields: Codable, Hashable {
        var workflows: [String]?
        var quickFixes: [String]?
        var description: String?
        var name: String
    }
}

