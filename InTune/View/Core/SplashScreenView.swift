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
        ZStack {
            if isActive {
                ContentView()
            } else {
                VStack {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 187, height: 231)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
            }
        }
        .onAppear(perform: startAnimation)
    }

    private func startAnimation() {
        // Fade + scale animation
        withAnimation(.interpolatingSpring(stiffness: 40, damping: 5).delay(0.2)) {
            scale = 1.0
            opacity = 1.0
        }

        // Navigate to main view
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut) {
                isActive = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
