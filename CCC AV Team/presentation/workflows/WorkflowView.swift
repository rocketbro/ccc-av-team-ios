//
//  WorkflowView.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct WorkflowView: View {
    @AppStorage(AppDefaults.userAuthenticatedKey) private var userAuthenticated = false
    
    private var globalImageSize: ImageSize {
        let size: String? = UserDefaults.standard.string(forKey: AppDefaults.globalImageSizeKey)
        var imageSize = ImageSize.Medium
        
        if let size = size {
            switch size {
            case "Small": imageSize = ImageSize.Small
            case "Medium": imageSize = ImageSize.Medium
            case "Large": imageSize = ImageSize.Large
            default: imageSize = ImageSize.Medium
            }
        }
        
        return imageSize
    }
    
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
    
    private var tsOptions: [String] {
        let tsOptions: [String] = steps[currentIndex].fields.tsOptions ?? []
        return tsOptions
    }
    
    private var maxImageWidth: CGFloat {
        if hSizeClass == .regular { 475 } else { 375 }
    }
    
    private var avImageId: String? {
        guard let avImageId = steps[currentIndex].fields.avImageId?.first else { return nil }
        return avImageId
    }
    
    @AppStorage(AppDefaults.imageAspectRatioKey) private var imageAspectRatio = ImageAspectRatio.standard
    
    private var ratio: (CGFloat, CGFloat) {
        switch imageAspectRatio {
        case .standard: return (4,3)
        case .wide: return (16,9)
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                
                // MARK: Image
                if let avImageId = avImageId {
                    //let imageUrl = dataManager.generateAzureURL(imageFileName: avImageId, imageSize: globalImageSize)
                    
                    let avImage = dataManager.loadCachedImage(avImageId: avImageId)
                    
                    if let avImage {
                        Image(uiImage: avImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: (maxImageWidth / ratio.0) * ratio.1)
                            .frame(maxWidth: maxImageWidth)
                            .cornerRadius(12)
                    } else {
                        HStack {
                            Spacer()
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle")
                                Text("Error loading image")
                                    .font(.footnote)
                                    .multilineTextAlignment(.center)
                            }
                            Spacer()
                        }
                        .frame(height: (maxImageWidth / ratio.0) * ratio.1)
                        .frame(maxWidth: maxImageWidth)
                        .background(.red.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    //                    AsyncImage(url: imageUrl) { phase in
                    //                        if let image = phase.image {
                    //                            image
                    //
                    //                        } else if phase.error != nil {
                    //                            HStack {
                    //                                Spacer()
                    //                                VStack(spacing: 12) {
                    //                                    Image(systemName: "exclamationmark.triangle")
                    //                                    Text("Error loading image\n\(imageUrl.absoluteString)")
                    //                                        .font(.footnote)
                    //                                        .multilineTextAlignment(.center)
                    //                                }
                    //                                Spacer()
                    //                            }
                    //                            .frame(height: (maxImageWidth / ratio.0) * ratio.1)
                    //                            .frame(maxWidth: maxImageWidth)
                    //                            .background(.red.opacity(0.1))
                    //                            .cornerRadius(12)
                    //                        } else {
                    //                            HStack {
                    //                                Spacer()
                    //                                ProgressView()
                    //                                Spacer()
                    //                            }
                    //                            .frame(height: (maxImageWidth / ratio.0) * ratio.1)
                    //                            .frame(maxWidth: maxImageWidth)
                    //                            .background(.ultraThinMaterial)
                    //                            .cornerRadius(12)
                    //                        }
                    //                    }.padding()
                } else {
                    HStack {
                        Text(workflow.fields.title)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                
                // MARK: WorkflowStep Prompt
                ScrollView {
                    VStack {
                        HStack {
                            Text(steps[currentIndex].fields.prompt)
                                .font(.body)
                                .monospaced()
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        if let sensitiveData = steps[currentIndex].fields.sensitiveData {
                            if userAuthenticated {
                                HStack {
                                    Text(sensitiveData)
                                        .font(.body)
                                        .monospaced()
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.orange)
                                    Spacer()
                                }.padding(.vertical)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                if avImageId == nil {
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
                    Image(systemName: "questionmark.circle.fill")
                        .font(.title2)
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
            .navigationTitle(avImageId == nil ? "" : workflow.fields.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

