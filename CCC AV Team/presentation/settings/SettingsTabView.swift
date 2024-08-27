//
//  File.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct SettingsTabView: View {
    @AppStorage(AppDefaults.pullDataKey) var pullData = true
    @AppStorage(AppDefaults.imageAspectRatioKey) var aspectRatio = ImageAspectRatio.standard
    @AppStorage(AppDefaults.globalImageSizeKey) var globalImageSize = ImageSize.Medium
    
//    @State private var aspectRatioLocal: ImageAspectRatio = .standard
//    @State private var localImageSize: ImageSize = .Medium
    
    var body: some View {
        NavigationStack {
            List {
                Toggle("Pull Server Data on Launch", isOn: $pullData)
                    .tint(.mint)
                
                Section {
                    Picker("Image Aspect Ratio", selection: $aspectRatio) {
                        ForEach(ImageAspectRatio.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    Picker("Image Quality", selection: $globalImageSize) {
                        ForEach(ImageSize.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }

                } header: { Text("Workflow Image Settings")}
                
            }
            Text(verbatim: """
CCC AV Team | Version \(Bundle.main.appVersion).\(Bundle.main.appBuild)
Developed by Asher Pope
asher@asherpope.com
""")
                .font(.footnote)
                .monospaced()
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.vertical, 48)
            
            .navigationTitle("Settings")
        }
    }
}
