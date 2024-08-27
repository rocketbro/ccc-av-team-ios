//
//  AppDefaults.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/23/24.
//

import Foundation

struct AppDefaults {
    static let firstLaunchKey = "hasLaunchedBefore"
    static let pullDataKey = "pullData"
    static let imageAspectRatioKey = "imageAspectRatio"
    static let globalImageSizeKey = "globalImageSize"

    static func initializeDefaults() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: firstLaunchKey)
        
        if !hasLaunchedBefore {
            // First launch, set the default value for pullData & imageAspectRatio
            UserDefaults.standard.set(true, forKey: pullDataKey)
            UserDefaults.standard.set(ImageAspectRatio.standard, forKey: imageAspectRatioKey)
            UserDefaults.standard.set(ImageSize.Medium, forKey: globalImageSizeKey)
            // Mark that the app has been launched before
            UserDefaults.standard.set(true, forKey: firstLaunchKey)
            
        }
        
    }
}
