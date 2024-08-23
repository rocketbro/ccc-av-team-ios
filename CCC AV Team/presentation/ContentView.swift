//
//  ContentView.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WorkflowTabView()
                .navigationTitle("Workflows")
                .tabItem {
                    Label("Workflows", systemImage: "flowchart.fill") // System image for workflows
                }
            
            QuickFixTabView()
                .tabItem {
                    Label("QuickFixes", systemImage: "wrench.fill") // System image for quick fixes
                }
            
//            SearchTabView()
//                .tabItem {
//                    Label("Search", systemImage: "magnifyingglass") // System image for search
//                }
            
            SettingsTabView()
                .tabItem {
                    Label("Settings", systemImage: "gear") // System image for settings
                }
            
            
            //            CoursesView()
            //                .tabItem {
            //                    Label("Courses", systemImage: "graduationcap.fill") // System image for quick fixes
            //                }
            //
            //            DocumentationView()
            //                .tabItem {
            //                    Label("Documentation", systemImage: "doc.text.fill") // System image for documentation
            //                }
            //
            //            TeamView()
            //                .tabItem {
            //                    Label("Team", systemImage: "person.3.fill") // System image for team
            //                }
        }
    }
}

// Placeholder views for each tab
struct CoursesView: View {
    var body: some View {
        NavigationStack {
            Text("Coming soon!")
                .navigationTitle("AV Courses")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct QuickFixesView: View {
    var body: some View {
        NavigationStack {
            Text("Coming soon!")
                .navigationTitle("QuickFixes")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct DocumentationView: View {
    var body: some View {
        NavigationStack {
            Text("Coming soon!")
                .navigationTitle("Documentation")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct TeamView: View {
    var body: some View {
        NavigationStack {
            Text("Coming soon!")
                .navigationTitle("AV Team")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}


#Preview {
    ContentView()
}
