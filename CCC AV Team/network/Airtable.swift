//
//  airtable.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation

// define required operations for interacting with Airtable
protocol AirtableService {
    func fetchTable<T: Codable>(_ table: TableName) async throws -> [T]
}


// generic wrapper for Airtable response object
struct AirtableResponse<T: Codable>: Codable {
    let records: [T]
}

struct Airtable: AirtableService {
    private let baseId: String
    private let token: String
    
    init(baseId: String, token: String) {
        self.baseId = baseId
        self.token = token
    }
    
    // Updated function to use async/await
    func fetchTable<T: Codable>(_ table: TableName) async throws -> [T] {
        let url = URL(string: "https://api.airtable.com/v0/\(baseId)/\(table.rawValue)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedResponse = try decoder.decode(AirtableResponse<T>.self, from: data)
        return decodedResponse.records
    }
}


let airtable = Airtable(
    baseId: airtableBaseId,
    token: airtableToken
)
