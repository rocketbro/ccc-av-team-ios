//
//  RoundedButton.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct RoundedButton: View {
    let text: String
    let tint: Color
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var backgroundTint: Color {
        if tint == .primary {
            return .primary
        } else {
            return tint.opacity(0.25)
        }
    }
    
    var foregroundTint: Color {
        if tint == .primary {
            if colorScheme == .dark {
                return .black
            } else {
                return .white
            }
        } else {
            return tint
        }
    }
    
    init(_ text: String, tint: Color, action: @escaping () -> Void) {
        self.text = text
        self.tint = tint
        self.action = action
    }
    
    var body: some View {
        Text(text)
            .fontWeight(.semibold)
            .foregroundStyle(foregroundTint)
            .padding(.horizontal, 28)
            .padding(.vertical, 24)
            .background(backgroundTint)
            .cornerRadius(100)
            .monospaced()
            .onTapGesture {
                self.action()
            }
    }
}

#Preview {
    RoundedButton("next", tint: .mint) { }
}

