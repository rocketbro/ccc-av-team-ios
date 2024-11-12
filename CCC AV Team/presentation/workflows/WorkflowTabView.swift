//
//  WorkflowTabView.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct WorkflowTabView: View {
    private var flows: [Workflow] = dataManager.loadFromDisk(table: .WORKFLOWS) ?? [Workflow()]
    private var categories: [AVCategory] = dataManager.loadFromDisk(table: .AV_CATEGORIES) ?? []
    
    var body: some View {
        if flows.isEmpty {
            Text("No workflows saved.")
        } else {
            NavigationStack {
                List {
                    ForEach(categories) { category in
                        WorkflowSectionView(category: category, flows: filteredWorkflows(for: category))
                    }
                }
                .navigationTitle("Workflows")
            }
        }
    }
    
    private func filteredWorkflows(for category: AVCategory) -> [Workflow] {
        flows.filter { $0.fields.avCategory.first == category.id }
    }
}

struct WorkflowSectionView: View {
    var category: AVCategory
    var flows: [Workflow]
    
    var body: some View {
        if !flows.isEmpty {
            Section(header: Text(category.fields.name)) {
                ForEach(flows) { workflow in
                    NavigationLink(workflow.fields.title) {
                        WorkflowView(workflow: workflow)
                    }
                }
            }
        }
    }
}


