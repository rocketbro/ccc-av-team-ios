//
//  AuthenticationSheet.swift
//  CCC AV Team
//
//  Created by Asher Pope on 11/12/24.
//

import SwiftUI

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
                RoundedButton("Enter", tint: .accent) {
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
