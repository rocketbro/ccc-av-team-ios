//
//  Airtable_Impl.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import Foundation

class AirtableManager {
    private let airtableService: AirtableService
    private let queue = DispatchQueue(label: "com.av-team.AirtableManagerQueue")
    
    init(airtableService: AirtableService) {
        self.airtableService = airtableService
    }
    
    // Updated to use async/await
    func fetchWorkflows() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            queue.async {
                Task {
                    do {
                        let workflows: [Workflow] = try await self.airtableService.fetchTable(.WORKFLOWS)
                        dataManager.saveToDisk(workflows, table: .WORKFLOWS)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    
    func fetchWorkflowSteps() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            queue.async {
                Task {
                    do {
                        let workflowSteps: [WorkflowStep] = try await self.airtableService.fetchTable(.WORKFLOW_STEPS)
                        dataManager.saveToDisk(workflowSteps, table: .WORKFLOW_STEPS)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    func fetchTsOptions() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            queue.async {
                Task {
                    do {
                        let tsOptions: [TroubleshootingOption] = try await self.airtableService.fetchTable(.TROUBLESHOOTING_OPTIONS)
                        dataManager.saveToDisk(tsOptions, table: .TROUBLESHOOTING_OPTIONS)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    func fetchQuickFixes() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            queue.async {
                Task {
                    do {
                        let quickFixes: [QuickFix] = try await self.airtableService.fetchTable(.QUICK_FIXES)
                        dataManager.saveToDisk(quickFixes, table: .QUICK_FIXES)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    func fetchAVCategories() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            queue.async {
                Task {
                    do {
                        let avCategories: [AVCategory] = try await self.airtableService.fetchTable(.AV_CATEGORIES)
                        dataManager.saveToDisk(avCategories, table: .AV_CATEGORIES)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

}


let airtableManager = AirtableManager(airtableService: airtable)

