//
//  DataManager.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation
import UIKit

class DataManager {
    
    private let imageCache = NSCache<NSString, NSData>()
    
    // Helper function to get the documents directory
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Generic save function for Codable objects
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
    
    // Generic load function for Codable objects
    func loadFromDisk<T: Codable>(table: TableName) -> T? {
        let filename = "\(table.rawValue).json"
        let documentsURL = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: documentsURL)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Failed to load \(filename): \(error)")
            return nil
        }
    }
    
    // Find an object by ID in a loaded array of Codable and Identifiable objects
    func findObjectById<T: Codable & Identifiable>(table: TableName, id: String) -> T? {
            guard let objects: [T] = self.loadFromDisk(table: table) else {
                return nil
            }
            return objects.first { $0.id as! String == id }
        }
    
    // MARK: Image Processing
    
    // Download and cache image, then save to documents directory
    func downloadAndSaveImage(from url: URL, filename: String) async throws -> URL? {
        let cacheKey = NSString(string: url.absoluteString)
        
        // Check cache first
        if let cachedData = imageCache.object(forKey: cacheKey) {
            print("Using cached image for \(url.absoluteString)")
            return saveImageToDocumentsDirectory(data: cachedData as Data, filename: filename)
        }
        
        // Download and cache if not found
        let (data, _) = try await URLSession.shared.data(from: url)
        imageCache.setObject(data as NSData, forKey: cacheKey)
        
        return saveImageToDocumentsDirectory(data: data, filename: filename)
    }
    
    // Load image from cache or documents directory
    func loadCachedImage(avImageId: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent("avImages/\(avImageId).jpg")
        let cacheKey = NSString(string: fileURL.absoluteString)
        
        // Check cache first
        if let cachedData = imageCache.object(forKey: cacheKey) {
            print("Using cached image for \(avImageId)")
            return UIImage(data: cachedData as Data)
        }
        
        // Load from disk if not cached
        do {
            let data = try Data(contentsOf: fileURL)
            imageCache.setObject(data as NSData, forKey: cacheKey)
            return UIImage(data: data)
        } catch {
            print("Error loading image from documents directory: \(error)")
            return nil
        }
    }
    
    // Save image data to documents directory
    func saveImageToDocumentsDirectory(data: Data, filename: String) -> URL? {
        let fileURL = getDocumentsDirectory().appendingPathComponent("avImages").appendingPathComponent(filename)
        
        // Create directory if it doesn't exist
        let directoryURL = fileURL.deletingLastPathComponent()
        do {
            if !FileManager.default.fileExists(atPath: directoryURL.path) {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }
            try data.write(to: fileURL)
            print("Image saved successfully at: \(fileURL)")
            return fileURL
        } catch {
            print("Error saving file: \(error)")
            return nil
        }
    }
    
    // Process and save an array of images asynchronously
    func processImages(_ avImages: [AVImage]) async {
        for avImage in avImages {
            if let fullThumbnailURLString = avImage.fields.image?.first?.thumbnails.full.url,
               let url = URL(string: fullThumbnailURLString) {
                let filename = "\(avImage.id).jpg"
                do {
                    if let localURL = try await downloadAndSaveImage(from: url, filename: filename) {
                        print("Image saved locally at \(localURL)")
                    }
                } catch {
                    print("Error downloading or saving image: \(error)")
                }
            }
        }
    }
}


let dataManager = DataManager()

