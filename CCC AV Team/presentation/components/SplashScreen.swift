//
//  SplashScreen.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/29/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var showProgress = false
    let pullData: Bool
    @Binding var dataFetched: Bool
    let onAppear: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle() // Or any other shape
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [colorFromHex("#1c3040").opacity(0.95), colorFromHex("#1c3040").opacity(0.45)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea()
                .zIndex(0)
            VStack {
                Spacer()
                Image("CCC_white")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 275)
                    .padding(.vertical, 32)
                Text("CCC Audiovisual Team")
                    .monospaced()
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                ProgressView()
                    .opacity(showProgress ? 1 : 0)
                    .padding(.vertical)
                
                Spacer()
                
//                Button(role: .cancel, action: {
//                    dataFetched = true
//                }, label: {
//                    Text("Skip Data Pull (may use outdated info)")
//                })
//                .buttonStyle(.bordered)
//                .padding(.vertical)
//                .tint(.orange)
//                .opacity(showProgress ? 1 : 0)
            }
            .zIndex(1)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if pullData {
                        withAnimation { showProgress.toggle() }
                    }
                    onAppear()
                }
            }
        }
    }
}
