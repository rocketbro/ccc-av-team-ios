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
    static let userAuthenticatedKey = "userAuthenticated"
    static let dataFetchedKey = "dataFetched"

    static func initializeDefaults() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: firstLaunchKey)
        
        if !hasLaunchedBefore {
            // First launch, set the default values
            UserDefaults.standard.set(true, forKey: pullDataKey)
            UserDefaults.standard.set(false, forKey: dataFetchedKey)
            UserDefaults.standard.set(ImageAspectRatio.standard.rawValue, forKey: imageAspectRatioKey)
            UserDefaults.standard.set(ImageSize.Medium.rawValue, forKey: globalImageSizeKey)
            UserDefaults.standard.set(false, forKey: userAuthenticatedKey)
            // Mark that the app has been launched before
            UserDefaults.standard.set(true, forKey: firstLaunchKey)
            
        }
        
    }
}
