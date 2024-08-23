//
//  QuickFixTabView.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct QuickFixTabView: View {
    private var quickfixes: [QuickFix] = dataManager.loadFromDisk(table: .QUICK_FIXES) ?? [QuickFix()]
    private var categories: [AVCategory] = dataManager.loadFromDisk(table: .AV_CATEGORIES) ?? []
    
    var body: some View {
        NavigationStack {
            if quickfixes.isEmpty {
                Text("No QuickFixes saved.")
            } else {
                List {
                    ForEach(categories) { category in
                        QuickFixSectionView(category: category, quickfixes: filteredQuickFixes(for: category))
                    }
                }
                .navigationTitle("QuickFixes")
            }
        }
    }
    
    private func filteredQuickFixes(for category: AVCategory) -> [QuickFix] {
        quickfixes.filter { $0.fields.avCategory?.first == category.id }
    }
}

struct QuickFixSectionView: View {
    var category: AVCategory
    var quickfixes: [QuickFix]
    
    var body: some View {
        if !quickfixes.isEmpty {
            Section(header: Text(category.fields.name)) {
                ForEach(quickfixes) { quickfix in
                    NavigationLink(quickfix.fields.title) {
                        QuickFixView(quickfix: quickfix)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
            }
        }
    }
}

