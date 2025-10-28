//
//  TopicExclusionView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct TopicExclusionView: View {
    @State private var goBack = false
    @State private var goNext = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            SingleQuestionView(
                question: "Anything you want to skip this time?",
                options: ["❌ Health & Disease", "❌ Politics", "❌ Crime", "❌ Celebrity gossip", "🚫 No filters"],
                currentQuestionIndex: 2,
                totalQuestions: 4,
                onBack: {
                    goBack = true
                },
                onNext: {
                    goNext = true
                },
                isFinalPage: false
            )
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $goNext) {
                TimeAvailabilityView()
            }
            .navigationDestination(isPresented: $goBack) {
                TopicView()
            }
        }
    }
}

#Preview {
    TopicExclusionView()
}
