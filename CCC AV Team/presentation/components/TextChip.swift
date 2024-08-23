//
//  TextChip.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct TextChip: View {
    let text: String
    let tint: Color
    
    init(_ text: String, tint: Color) {
        self.text = text
        self.tint = tint
    }
    
    var body: some View {
        Text(text)
            .foregroundStyle(tint)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(tint.opacity(0.25))
            .cornerRadius(8)
            .monospaced()
    }
}

#Preview {
    TextChip("Video", tint: .orange)
}

