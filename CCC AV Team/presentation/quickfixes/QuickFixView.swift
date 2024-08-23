//
//  QuickFixView.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct QuickFixView: View {
    let quickfix: QuickFix
    var related: [Workflow]
    var categories: [AVCategory]
    
    init(quickfix: QuickFix) {
        self.quickfix = quickfix
        self.related = []
        
        if let related = self.quickfix.fields.related {
            for workflowId in related {
                let workflow: Workflow? = dataManager.findObjectById(table: .WORKFLOWS, id: workflowId)
                if let workflow = workflow {
                    self.related.append(workflow)
                }
            }
        }
        
        self.categories = []
        
        if let categories = self.quickfix.fields.avCategory {
            for categoryId in categories {
                let category: AVCategory? = dataManager.findObjectById(table: .AV_CATEGORIES, id: categoryId)
                if let category = category {
                    self.categories.append(category)
                }
            }
        }
        
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text(quickfix.fields.title)
                    .font(.largeTitle)
                    .bold()
                HStack {
                    ForEach(self.categories) {
                        TextChip($0.fields.name, tint: .orange)
                    }
                    Spacer()
                }
                Text(quickfix.fields.description)
                    .padding(.bottom, 22)
                Text("SOLUTION")
                    .font(.headline)
                    .foregroundStyle(.mint)
                Text(quickfix.fields.solution)
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    QuickFixView(quickfix: QuickFix(id: "01", createdTime: "today", fields: QuickFix.Fields(index: 0, description: "There is a loud humming sound in the room, and you know it is coming from somewhere on the soundboard.", solution: "Stop the entire service and reboot the soundboard. If that doesn't do it, figure out something on YouTube.", avCategory: [], title: "Strange humming sound in the room.", related: [])))
}

