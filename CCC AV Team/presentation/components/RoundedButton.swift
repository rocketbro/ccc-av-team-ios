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
    
    init(_ text: String, tint: Color, action: @escaping () -> Void) {
        self.text = text
        self.tint = tint
        self.action = action
    }
    
    var body: some View {
        Text(text)
            .foregroundStyle(tint)
            .padding(.horizontal, 28)
            .padding(.vertical, 24)
            .background(tint.opacity(0.25))
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

