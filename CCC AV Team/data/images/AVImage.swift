//
//  AVImage.swift
//  CCC AV Team
//
//  Created by Asher Pope on 10/6/24.
//

import Foundation

struct AVImage: Codable, Hashable {
    var id: String = UUID().uuidString
    var createdTime: String = "\(Date.now)"
    var fields: Fields = Fields()

    // MARK: - Fields Struct
    struct Fields: Codable, Hashable {
        var name: String = "Unknown Image"
        var image: [Image]?

        // MARK: - Image Struct
        struct Image: Codable, Hashable {
            var id: String = UUID().uuidString
            var width: Int?
            var height: Int?
            var url: String?
            var filename: String?
            var size: Int?
            var type: String?
            var thumbnails: Thumbnails = Thumbnails()

            // MARK: - Thumbnails Struct
            struct Thumbnails: Codable, Hashable {
                var small: ThumbnailSize = ThumbnailSize()
                var large: ThumbnailSize = ThumbnailSize()
                var full: ThumbnailSize = ThumbnailSize()

                // MARK: - ThumbnailSize Struct
                struct ThumbnailSize: Codable, Hashable {
                    var url: String?
                    var width: Int?
                    var height: Int?
                }
            }
        }
    }
}
