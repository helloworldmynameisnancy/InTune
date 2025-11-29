//
//  SplashScreenView.swift
//  InTune
//
//  Created by Nancy Luu on 11/28/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0.0
    
    var body: some View {
        if isActive {
            HomeView()
        } else {
            VStack(spacing: 20) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 187, height: 231)
                    .scaleEffect(scale)
            }
            .onAppear {
                // Fade + scale animation
                withAnimation(.interpolatingSpring(stiffness: 40, damping: 5).delay(0.2)) {
                    scale = 1.0
                    opacity = 1.0
                }
                
                // Transition to main view
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    Group {
        SplashScreenView()
    }
}

