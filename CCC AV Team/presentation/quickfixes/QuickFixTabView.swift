//
//  QuickFixTabView.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct QuickFixTabView: View {
    //@State private var decoded: [QuickFix] = []
    private var quickfixes: [QuickFix] = dataManager.loadFromDisk(table: .QUICK_FIXES) ?? [QuickFix()]
    
    var body: some View {
        NavigationStack {
            if quickfixes.isEmpty {
                Text("No QuickFixes saved.")
            } else {
                List {
                    ForEach(quickfixes) { quickfix in
                        NavigationLink {
                            QuickFixView(quickfix: quickfix)
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            Text(quickfix.fields.title)
                        }
                    }
                }.navigationTitle("QuickFixes")
            }
        }
    }
}

#Preview("QuickFixTabView") {
    QuickFixTabView()
}

