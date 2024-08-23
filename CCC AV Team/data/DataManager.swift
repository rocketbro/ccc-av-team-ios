//
//  DataManager.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation

class DataManager {
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    // Generic save function
    func saveToDisk<T: Codable>(_ object: T, table: TableName) {
        let filename = "\(table.rawValue).json"
        let documentsURL = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: documentsURL)
        } catch {
            print("Failed to save \(filename): \(error)")
        }
    }
    
    // Generic load function
    func loadFromDisk<T: Codable>(table: TableName) -> T? {
        let filename = "\(table.rawValue).json"
        let documentsURL = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: documentsURL)
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Failed to load \(filename): \(error)")
            return nil
        }
    }
    
    func findObjectById<T: Codable & Identifiable>(table: TableName, id: String) -> T? {
        guard let objects: [T] = self.loadFromDisk(table: table) else {
            return nil
        }
        return objects.first { $0.id as! String == id }
    }
    
    func generateAzureURL(imageFileName: String, imageSize: ImageSize) -> URL {
        let azureDirectory: String = switch imageSize {
        case .Small: "images-small"
        case .Medium: "images-medium"
        case .Large: "images-large"
        }
        
        // format: https://avteam.blob.core.windows.net/images-medium/boot_projectors%20Medium.jpeg
        return URL(string: "https://avteam.blob.core.windows.net/\(azureDirectory)/\(imageFileName)%20\(imageSize.rawValue).jpeg")!
    }
    
}

let dataManager = DataManager()

