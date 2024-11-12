//
//  AVImage.swift
//  CCC AV Team
//
//  Created by Asher Pope on 10/6/24.
//

import Foundation

struct AVImage: Codable, Hashable {
    var id: String
    var createdTime: String
    var fields: Fields

    // MARK: - Fields Struct
    struct Fields: Codable, Hashable {
        var name: String?
        var image: [Image]?

        // MARK: - Image Struct
        struct Image: Codable, Hashable {
            var id: String
            var width: Int?
            var height: Int?
            var url: String?
            var filename: String?
            var size: Int?
            var type: String?
            var thumbnails: Thumbnails?

            // MARK: - Thumbnails Struct
            struct Thumbnails: Codable, Hashable {
                var small: ThumbnailSize?
                var large: ThumbnailSize?
                var full: ThumbnailSize?

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

//let testData = """
//{"id":"rec2BgxITbQmNYToq","createdTime":"2024-10-06T21:49:02.000Z","fields":{"image":[{"id":"attA1x7D0o5ggAdWr","width":1280,"height":960,"url":"https://v5.airtableusercontent.com/v3/u/35/35/1731441600000/MW1oH3iaZeecxwPqDswz3A/au6SpHqBBVv17JRSGOm-8bQUVvlcsA1_I9F6hNMswzT6VvfJd1bLE9FV11x-cL-JS7Dp5VTS0wtf5I7feneMn8b4LMPcr_c7dKZemtEZsN3I2awxSBCz5RwzOoRGD0cP6DiG09-WgfjfYydqSkwfnAEowMvrXcEnUxbcbcxni-eE95nvicoG84VXLYvIF64b/dZXi8pI8OXUQoC9R-D-8okf1ZQ1jllYkZQS9VL_2XuM","filename":"video_rack_power_on Large.jpeg","size":294133,"type":"image/jpeg","thumbnails":{"small":{"url":"https://v5.airtableusercontent.com/v3/u/35/35/1731441600000/0IGVweMHoem8ieQdxyKsFw/-1izfCpxfmaTVGqEKoazsYmGGxJP-4FfZe_noG-hFWPppFVVlLi13A0tCx4xr0cTRUYEnPgRxUECq1ScNVF6ZBy4EExWyPYcygvtBJ0EXhCLzM0aoehoxp3k343p831QuAIVZjBbJoEOQJMYq9V5JQ/pvU5-IIomMW6b7GKrSjf1C8lLgO43lEehElNMHzf-X8","width":48,"height":36},"large":{"url":"https://v5.airtableusercontent.com/v3/u/35/35/1731441600000/GG16xlvt6nSzJSXq02zIPw/DBylI0dgrwp6TSyXZq6Pom0GfOM5N794Zu_zU98PvmYEmVBl_T5ICyFpHjGBerVEUz075fIpX6LU0MaUlnhPYXVpuMGqSa0ODbiH-SKOE3K3Es_TtrHU3z7srfRNUji_yBpe1WcLNG9MSNpCQgcPqA/8djOJBLObx_zu4o5qQ5nQ3CB1vGp8eK99CI94shqIDY","width":683,"height":512},"full":{"url":"https://v5.airtableusercontent.com/v3/u/35/35/1731441600000/zl8jOKqV-841zVhGc2_z3Q/nQ0DImsZtf9Upnxw7UYOxZTsrS_PDDBxeDS2VdMJ_NDRWToSgVmpD3gTSFB0gXu2eO2G7e85l6Yu9J8-zrElzAoPfIZo5Fph52b4KgfalnEYb-L3M3RPRMBj6ZJadse8TITVuhCKMRJcLdL8gxRsDA/vTFJ7eAjXfNBaS-cNq0QnsThTnGDzLsXNbR6FVhUC0c","width":1280,"height":960}}}],"name":"video_rack_power_on"}}
//"""
//func testAVImageDecoding() {
//    do {
//        let test = try JSONDecoder().decode(AVImage.self, from: testData.data(using: .utf8)!)
//        print(test.fields.name)
//    } catch {
//        print(error.localizedDescription)
//    }
//}
