//
//  WorkflowView.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct WorkflowView: View {
    let workflow: Workflow
    var steps: [WorkflowStep]
    
    init(workflow: Workflow) {
        self.workflow = workflow
        self.steps = []
        
        for stepId in self.workflow.fields.steps {
            let step: WorkflowStep? = dataManager.findObjectById(table: .WORKFLOW_STEPS, id: stepId)
            if let step = step {
                self.steps.append(step)
                //print(step)
            }
            
        }
    }
    
    @State private var currentIndex: Int = 0
    @State private var showBottomSheet = false
    @Environment(\.horizontalSizeClass) var hSizeClass
    
    var tsOptions: [String] {
        let tsOptions: [String] = steps[currentIndex].fields.tsOptions ?? []
        return tsOptions
    }
    
    var maxImageWidth: CGFloat {
        if hSizeClass == .regular { 475 } else { 375 }
    }
    
    var imageFileName: String? {
        guard let imageFileName = steps[currentIndex].fields.imageFileName else { return nil }
        return imageFileName
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                
                // MARK: Image
                if let imageFileName = imageFileName {
                    let imageUrl = dataManager.generateAzureURL(imageFileName: imageFileName, imageSize: globalImageSize)
                    
                    AsyncImage(url: imageUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 275)
                                .frame(maxWidth: maxImageWidth)
                                .cornerRadius(18)
                        } else if phase.error != nil {
                            HStack {
                                Spacer()
                                VStack(spacing: 12) {
                                    Image(systemName: "exclamationmark.triangle")
                                    Text("Error loading image")
                                        .font(.footnote)
                                }
                                Spacer()
                            }
                            .frame(height: 300)
                            .frame(maxWidth: 475)
                            .background(.red.opacity(0.1))
                            .cornerRadius(18)
                        } else {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .frame(height: 300)
                            .frame(maxWidth: 475)
                            .background(.ultraThinMaterial)
                            .cornerRadius(18)
                        }
                    }.padding()
                } else {
                    Spacer()
                }
                
                // MARK: WorkflowStep Prompt
                HStack {
                    Text(steps[currentIndex].fields.prompt)
                        .font(.body)
                        .monospaced()
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal)
                
                if imageFileName == nil {
                    Spacer()
                }
            }
        }
        
        Spacer()
        
        // MARK: Prev & Next nav
        HStack { // nav menu
            
            RoundedButton("Prev", tint: currentIndex > steps.startIndex ? .mint : .gray) {
                if currentIndex > steps.startIndex {
                    currentIndex -= 1
                }
            }
            
            
            Spacer()
            
            if !tsOptions.isEmpty {
                Button(action: {
                    showBottomSheet.toggle()
                }, label: {
                    Image(systemName: "questionmark.circle")
                })
                .tint(.orange)
                .sheet(isPresented: $showBottomSheet, content: {
                    TSOptionView(tsOptions: tsOptions)
                })
            }
            
            Spacer()
            
            RoundedButton("Next", tint: currentIndex < (steps.count - 1) ? .mint : .gray) {
                if currentIndex < (steps.count - 1) {
                    currentIndex += 1
                }
            }
        }.padding()
            .navigationTitle(workflow.fields.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

