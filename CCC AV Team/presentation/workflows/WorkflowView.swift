//
//  WorkflowView.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

struct WorkflowView: View {
    @AppStorage(AppDefaults.userAuthenticatedKey) private var userAuthenticated = false
    @AppStorage(AppDefaults.imageAspectRatioKey) var aspectRatio = ImageAspectRatio.standard.rawValue
    
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
    var imageDict: [String:URL] {
        if let fetchedImages: [AVImage] = dataManager.loadFromDisk(table: .AV_IMAGES) {
            let dict = dataManager.processImages(fetchedImages)
            return dict
        } else {
            return [:]
        }
    }
    
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
                Spacer()
                
                // MARK: Image
                if let avImageId = avImageId {
                    let avImageUrl = imageDict[avImageId]
                    
                    
                    GeometryReader { geometry in
                        AsyncImage(url: avImageUrl) { phase in
                            switch phase {
                            case .empty:
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .frame(width: geometry.size.width)
                                .frame(height: geometry.size.width * (ratio.1 / ratio.0))
                                .background(.primary.opacity(0.1))
                                .cornerRadius(12)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width)
                                    .frame(height: geometry.size.width * (ratio.1 / ratio.0))
                                    .clipped()
                                    .cornerRadius(12)
                            case .failure(_):
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
                                .frame(width: geometry.size.width)
                                .frame(height: geometry.size.width * (ratio.1 / ratio.0))
                                .background(.red.opacity(0.1))
                                .cornerRadius(12)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    .aspectRatio(ratio.0 / ratio.1, contentMode: .fill)
                    .padding(.horizontal)
                    
                    
                    //                    if let avImage {
                    //                        Image(uiImage: avImage)
                    //                            .resizable()
                    //                            .scaledToFill()
                    //                            .frame(height: (maxImageWidth / ratio.0) * ratio.1)
                    //                            .frame(maxWidth: maxImageWidth)
                    //                            .cornerRadius(12)
                    //                    } else {
                    //                        HStack {
                    //                            Spacer()
                    //                            VStack(spacing: 12) {
                    //                                Image(systemName: "exclamationmark.triangle")
                    //                                Text("Error loading image")
                    //                                    .font(.footnote)
                    //                                    .multilineTextAlignment(.center)
                    //                            }
                    //                            Spacer()
                    //                        }
                    //                        .frame(height: (maxImageWidth / ratio.0) * ratio.1)
                    //                        .frame(maxWidth: maxImageWidth)
                    //                        .background(.red.opacity(0.1))
                    //                        .cornerRadius(12)
                    //                    }
                    
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
                                        .foregroundStyle(.red)
                                    Spacer()
                                }.padding(.vertical)
                            }
                        }
                    }
                    .padding()
                }
                
                if avImageId == nil {
                    Spacer()
                }
            }
        }
        
        
        
        // MARK: Prev & Next nav
        HStack { // nav menu
            
            RoundedButton("Prev", tint: currentIndex > steps.startIndex ? .primary : .gray) {
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
                .tint(.accent)
                .sheet(isPresented: $showBottomSheet, content: {
                    TSOptionView(tsOptions: tsOptions)
                })
            }
            
            Spacer()
            
            RoundedButton("Next", tint: currentIndex < (steps.count - 1) ? .primary : .gray) {
                if currentIndex < (steps.count - 1) {
                    currentIndex += 1
                }
            }
        }
        .padding()
        .padding(.bottom)
        .navigationTitle(avImageId == nil ? "" : workflow.fields.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if avImageId != nil {
                ToolbarItem {
                    Menu {
                        Picker("Image Size", selection: $aspectRatio) {
                            ForEach(ImageAspectRatio.allCases, id: \.self) {
                                Text($0.rawValue).tag($0.rawValue)
                            }
                        }
                    } label: {
                        Image(systemName: "photo")
                    }
                }
            }
        }
    }
    
}

