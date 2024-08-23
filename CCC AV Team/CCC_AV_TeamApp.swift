//
//  CCC_AV_TeamApp.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

@main
struct CCC_AV_Team: App {
    @State private var dataFetched = false
    private let dispatchGroup = DispatchGroup()
    
    private var pullData: Bool { UserDefaults.standard.bool(forKey: "pullData") }
    
    var body: some Scene {
        WindowGroup {
            if dataFetched {
                ContentView()
            } else {
                VStack {
                    Spacer()
                    ProgressView("Pulling data...")
                        .onAppear {
                            if pullData {
                                Task {
                                    await loadData()
                                }
                            } else {
                                dataFetched = true
                            }
                        }
                    Spacer()
                    Button(role: .cancel, action: {
                        dataFetched = true
                    }, label: {
                        Label("Skip Data Pull (may use outdated info)", systemImage: "xmark.octagon")
                    })
                    .padding()
                    .tint(.red)
                }
            }
        }
    }

    // Asynchronous data loading function
    private func loadData() async {
        // Enter the DispatchGroup for each fetch task
        dispatchGroup.enter()
        Task {
            await fetchAndSaveWorkflows()
            Logger.shared.log("Downloaded Workflows", level: .info)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        Task {
            await fetchAndSaveWorkflowSteps()
            Logger.shared.log("Downloaded WorkflowSteps", level: .info)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        Task {
            await fetchAndSaveTsOptions()
            Logger.shared.log("Downloaded TroubleshootingOptions", level: .info)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        Task {
            await fetchAndSaveQuickFixes()
            Logger.shared.log("Downloaded QuickFixes", level: .info)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        Task {
            await fetchAndSaveAVCategories()
            Logger.shared.log("Downloaded AVCategories", level: .info)
            dispatchGroup.leave()
        }

        // Notify when all tasks are completed
        dispatchGroup.notify(queue: .main) {
            Logger.shared.log("Fetched all Airtable data", level: .info)
            dataFetched = true
        }
    }

    // Fetch and save functions
    private func fetchAndSaveWorkflows() async {
        do {
            try await airtableManager.fetchWorkflows()
        } catch {
            Logger.shared.log("Error: \(error.localizedDescription)", level: .error)
        }
    }

    private func fetchAndSaveWorkflowSteps() async {
        do {
            try await airtableManager.fetchWorkflowSteps()
        } catch {
            Logger.shared.log("Error: \(error.localizedDescription)", level: .error)
        }
    }

    private func fetchAndSaveTsOptions() async {
        do {
            try await airtableManager.fetchTsOptions()
        } catch {
            Logger.shared.log("Error: \(error.localizedDescription)", level: .error)
        }
    }

    private func fetchAndSaveQuickFixes() async {
        do {
            try await airtableManager.fetchQuickFixes()
        } catch {
            Logger.shared.log("Error: \(error.localizedDescription)", level: .error)
        }
    }

    private func fetchAndSaveAVCategories() async {
        do {
            try await airtableManager.fetchAVCategories()
        } catch {
            Logger.shared.log("Error: \(error.localizedDescription)", level: .error)
        }
    }
}