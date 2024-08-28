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
                        .tint(.mint)
                    if userAuthenticated {
                        Button("Refresh App Data") {
                            dataFetched.toggle()
                        }
                    }
                } header: { Text("Content Data") }
                
                Section {
                    Picker("Image Aspect Ratio", selection: $aspectRatio) {
                        ForEach(ImageAspectRatio.allCases, id: \.self) {
                            Text($0.rawValue).tag($0.rawValue)
                        }
                    }
                    Picker("Image Quality", selection: $globalImageSize) {
                        ForEach(ImageSize.allCases, id: \.self) {
                            Text($0.rawValue).tag($0.rawValue)
                        }
                    }
                    
                } header: { Text("Workflow Images")}
                
                Section {
                    if userAuthenticated {
                        Text("Signed in as AV Team Member")
                            .foregroundStyle(.gray)
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
                } header: { Text("User Settings") }
                
                
            }
            .navigationTitle("Settings")
            
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
        }
    }
}

struct AuthenticationSheet: View {
    @Binding var isPresented: Bool
    @Binding var userAuthenticated: Bool
    
    @State private var passcodeText = ""
    @State private var showError = false
    @State private var firstAttempt = true
    
    var errorMessages = [
        "Wrong passcode, try again. Maybe you’re a secret agent in disguise?",
        "Oops! That ain't it. Try again.",
        "Nice try, but the passcode fairy didn’t bless you this time.",
        "Hmm, that’s not the passcode. Are you sure you’re not a robot?",
        "Incorrect passcode. If at first you don’t succeed, try, try, try again!",
        "That’s not it. Perhaps you should call a psychic for help.",
        "Close, but no cigar. Your passcode is still a mystery.",
        "Looks like you’re trying to unlock a treasure chest with the wrong key.",
        "Nope, that’s not the passcode. Have you tried shaking the phone to see if it helps?",
        "No good. Did you try turning it off and on again?",
        "The passcode you entered is incorrect. Have you tried guessing?",
        "Wrong code. Is this a secret test of your persistence?",
        "Passcode incorrect. Do you need a hint? Just kidding, keep trying.",
        "That’s not the one. Are you testing the system or just making things interesting?",
        "Incorrect passcode. Did you remember to read the manual?",
        "Oops! Wrong passcode. Maybe it’s time to consult chatGPT.",
        "Fail! The passcode doesn’t match. Maybe try a more secure guess?",
        "Wrong passcode. It’s almost like you’re playing a game of ‘guess the right code’."
    ]
    
    @State private var errorText = "Wrong passcode, please try again."

    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Enter the passcode provided by the AV Team Manager.")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            
            SecureField("Passcode", text: $passcodeText)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            if showError {
                Text(errorText)
                    .font(.caption)
                    .monospaced()
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom)
                
            }
            
            HStack(spacing: 32) {
                RoundedButton("Cancel", tint: .red) {
                    isPresented.toggle()
                }
                RoundedButton("Enter", tint: .mint) {
                    if passcodeText == "i am legit" {
                        userAuthenticated = true
                        isPresented.toggle()
                    } else {
                        withAnimation {
                            if firstAttempt {
                                showError = true
                                passcodeText = ""
                                firstAttempt = false
                            } else {
                                passcodeText = ""
                                errorText = errorMessages.randomElement()!
                            }
                        }
                    }
                }
            }
            
            Spacer()
            Spacer()
            
        }
        
    }
}

