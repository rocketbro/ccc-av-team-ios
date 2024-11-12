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
    @State private var showHome = false
    
    @AppStorage(AppDefaults.pullDataKey) var pullData = true
    @AppStorage(AppDefaults.dataFetchedKey) var dataFetched = false
    
    var body: some Scene {
        WindowGroup {
            if showHome {
                ContentView()
                    .preferredColorScheme(.dark)

            } else {
                SplashScreen(pullData: pullData, dataFetched: $dataFetched) {
                    if pullData {
                        Task {
                            await loadData()
                        }
                    } else {
                        withAnimation {
                            dataFetched = true
                            showHome.toggle()
                        }
                    }
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
            await fetchAndSaveAVImages()
            Logger.shared.log("Downloaded AVImages", level: .info)
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
            withAnimation {
                dataFetched = true
                showHome.toggle()
            }
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
    
    private func fetchAndSaveAVImages() async {
        do {
            try await airtableManager.fetchAVImages()
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
