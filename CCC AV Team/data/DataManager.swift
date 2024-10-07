//
//  DataManager.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation
import UIKit

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
    
    // MARK: Image Processing
    
    let imageCache = NSCache<NSString, NSData>()
    
    func downloadAndSaveImage(from url: URL, filename: String) async throws -> URL? {
        let cacheKey = NSString(string: url.absoluteString)
        
        // Check if the image is already cached
        if let cachedData = imageCache.object(forKey: cacheKey) {
            print("Using cached image for \(url.absoluteString)")
            return saveImageToDocumentsDirectory(data: cachedData as Data, filename: filename)
        }
        
        // If not cached, download the image
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Cache the image data
        imageCache.setObject(data as NSData, forKey: cacheKey)
        
        // Save the downloaded image to documents directory
        return saveImageToDocumentsDirectory(data: data, filename: filename)
    }
    
    
    // Load image using avImageId
    func loadCachedImage(avImageId: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent("avImages/\(avImageId).jpg")
        let cacheKey = NSString(string: url.absoluteString)
        
        // Check the cache for the image data
        if let cachedData = imageCache.object(forKey: cacheKey) {
            print("Using cached image for \(avImageId)")
            return UIImage(data: cachedData as Data)
        }
        
        // If not found in cache, load from documents directory
        do {
            let data = try Data(contentsOf: url)
            
            // Cache the loaded image data
            imageCache.setObject(data as NSData, forKey: cacheKey)
            print("Loaded and cached image from documents directory for \(avImageId)")
            
            // Return the image
            return UIImage(data: data)
        } catch {
            print("Error loading image from documents directory: \(error)")
            return nil
        }
    }

    
    func saveImageToDocumentsDirectory(data: Data, filename: String) -> URL? {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            // Define the subdirectory (e.g., "avImages")
            let subdirectoryURL = documentsDirectory.appendingPathComponent("avImages")
            
            // Create the subdirectory if it doesn't exist
            if !fileManager.fileExists(atPath: subdirectoryURL.path) {
                do {
                    try fileManager.createDirectory(at: subdirectoryURL, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error creating directory: \(error)")
                    return nil
                }
            }
            
            let fileURL = subdirectoryURL.appendingPathComponent(filename)
            
            do {
                try data.write(to: fileURL)
                print("Image saved successfully at: \(fileURL)")
                return fileURL
            } catch {
                print("Error saving file: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func processImages(_ avImages: [AVImage]) async {
        for avImage in avImages {
            if let fullThumbnailURLString = avImage.fields.image?.first?.thumbnails.full.url,
               let url = URL(string: fullThumbnailURLString) {
                
                let filename = "\(avImage.id).jpg"
                do {
                    if let localURL = try await downloadAndSaveImage(from: url, filename: filename) {
                        print("Image saved locally at \(localURL)")
                        // need to track these URLs
                    }
                } catch {
                    print("Error downloading or saving image: \(error)")
                }
            }
        }
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

