//
//  WorkflowTabView.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct WorkflowTabView: View {
    //@State private var decoded: [QuickFix] = []
    private var flows: [Workflow] = dataManager.loadFromDisk(table: .WORKFLOWS) ?? [Workflow()]
    
    var body: some View {
        if flows.isEmpty {
            Text("No workflows saved.")
        } else {
            NavigationStack {
                List {
                    ForEach(flows) { workflow in
                        NavigationLink(workflow.fields.title) {
                            WorkflowView(workflow: workflow)
                                .toolbar(.hidden, for: .tabBar)
                        }
                    }
                }.navigationTitle("Workflows")
            }
        }
    }
}

