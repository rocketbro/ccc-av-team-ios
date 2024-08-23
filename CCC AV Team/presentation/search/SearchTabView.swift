//
//  SearchTabView.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct SearchTabView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
//            TextField("Search AV Team content", text: $searchText)
//                .navigationTitle("Search")
//                .textFieldStyle(.roundedBorder)
            Spacer()
            Text("This feature will be implemented in a future release.")
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .monospaced()
                .padding()
                .navigationTitle("Search")
            Spacer()
        }
    }
}

#Preview {
    SearchTabView()
}

