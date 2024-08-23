//
//  File.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct SettingsTabView: View {
    @AppStorage(AppDefaults.pullDataKey) var pullData = true
    var body: some View {
        NavigationStack {
            List {
                Toggle("Pull Server Data on Launch", isOn: $pullData)
                    .tint(.mint)
            }
            Text(verbatim: "CCC AV Team\nVersion 0.1.1\nDeveloped by Asher Pope\nasher@asherpope.com")
                .font(.footnote)
                .monospaced()
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.vertical, 48)
            
            .navigationTitle("Settings")
        }
    }
}
