//
//  TopicExclusionView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct TopicExclusionView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @Environment(\.dismiss) var dismiss
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
                    dismiss()
                },
                onNext: {
                    withAnimation(.none) {
                        goNext = true
                    }
                },
                isFinalPage: false
            )
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $goNext) {
                TimeAvailabilityView()
            }
        }
    }
}

#Preview {
    TopicExclusionView()
        .environmentObject(SavedArticlesViewModel())
}
