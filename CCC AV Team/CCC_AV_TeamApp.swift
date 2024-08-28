//
//  CCC_AV_TeamApp.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

@main
struct CCC_AV_Team: App {
    private let dispatchGroup = DispatchGroup()
    
    @AppStorage(AppDefaults.pullDataKey) var pullData = true
    @AppStorage(AppDefaults.dataFetchedKey) var dataFetched = false
    
    var body: some Scene {
        WindowGroup {
            if dataFetched {
                ContentView()
                    .preferredColorScheme(.dark)

            } else {
                VStack {
                    Spacer()
                    Image("CCC_white")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .opacity(0.75)
                        .padding(.vertical, 32)
                    ProgressView("Pulling data...")
                        .onAppear {
                            
                            AppDefaults.initializeDefaults()
                            
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
                        Text("Skip Data Pull (may use outdated info)")
                    })
                    .buttonStyle(.bordered)
                    .padding(.vertical)
                    .tint(.red)
                }
                .preferredColorScheme(.dark)
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
