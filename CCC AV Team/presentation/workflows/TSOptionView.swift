//
//  TSOptionView.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct TSOptionView: View {
    let tsOptions: [String]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Troubleshooting")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                    .padding(.bottom, 30)
                ForEach(tsOptions, id: \.self) { tsOption in
                    let option: TroubleshootingOption? = dataManager.findObjectById(table: .TROUBLESHOOTING_OPTIONS, id: tsOption)
                    Text(option?.fields.prompt ?? "error")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.red)
                        .monospaced()
                    Text("\n\(option?.fields.solution ?? "error")")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .monospaced()
                    Divider()
                        .padding(.vertical)
                }
                Spacer()
            }
        }
        .padding()
        .presentationDetents([.medium, .large]) // This allows it to be draggable from medium to large sizes
    }
}

