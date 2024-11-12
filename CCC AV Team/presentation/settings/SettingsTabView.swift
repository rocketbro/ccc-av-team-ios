//
//  File.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct SettingsTabView: View {
    @AppStorage(AppDefaults.pullDataKey) var pullData = true
    @AppStorage(AppDefaults.dataFetchedKey) var dataFetched = true
    @AppStorage(AppDefaults.imageAspectRatioKey) var aspectRatio = ImageAspectRatio.standard.rawValue
    @AppStorage(AppDefaults.globalImageSizeKey) var globalImageSize = ImageSize.Medium.rawValue
    @AppStorage(AppDefaults.userAuthenticatedKey) var userAuthenticated = false
    
    @State private var showingAuthSheet = false
    @State private var showingConfirmationAlert = false
    
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Pull Server Data on Launch", isOn: $pullData)
                        .tint(.accentColor)
                    if userAuthenticated && pullData {
                        Button("Refresh App Data") {
                            withAnimation {
                                dataFetched.toggle()
                            }
                        }
                    }
                } header: { Text("Content Data") }
                
                Section {
                    Picker("Image Aspect Ratio", selection: $aspectRatio) {
                        ForEach(ImageAspectRatio.allCases, id: \.self) {
                            Text($0.rawValue).tag($0.rawValue)
                        }
                    }
//                    Picker("Image Quality", selection: $globalImageSize) {
//                        ForEach(ImageSize.allCases, id: \.self) {
//                            Text($0.rawValue).tag($0.rawValue)
//                        }
//                    }
                    
                } header: { Text("Workflow Images")}
                
                Section {
                    if userAuthenticated {
                        Button("Sign Out") { showingConfirmationAlert.toggle() }
                            .tint(.red)
                            .alert("Are you sure?", isPresented: $showingConfirmationAlert) {
                                Button("Cancel", role: .cancel) { }
                                Button("Sign Out", role: .destructive) {
                                    withAnimation {
                                        userAuthenticated = false
                                    }
                                }
                            } message: {
                                Text("You will need to log in again to view sensitive data in Workflows.")
                            }
                    } else {
                        Button("Sign In") { showingAuthSheet.toggle() }
                            .sheet(isPresented: $showingAuthSheet) {
                                AuthenticationSheet(
                                    isPresented: $showingAuthSheet,
                                    userAuthenticated: $userAuthenticated
                                )
                            }
                    }
                } header: { Text("User Settings") } footer: {
                    Text(userAuthenticated ? "Signed in as AV Team Member" : "")
                        .monospaced()
                }
                
                
            }
            .navigationTitle("Settings")
            
            Text("""
CCC AV Team | Version \(Bundle.main.appVersion).\(Bundle.main.appBuild)
Developed by Intrinsic Labs LLC
helloworld@intrinsiclabs.co
""")
            .font(.footnote)
            .monospaced()
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
            .padding(.vertical, 48)
        }
    }
}



