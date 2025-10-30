//
//  TopicView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct TopicView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @Environment(\.dismiss) var dismiss
    @State private var goNext = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            SingleQuestionView(
                question: "What topics interest you at the moment?",
                options: ["💻 Technology", "🏛 Politics", "🌍 World news", "🎨 Arts & Culture", "🩺 Health", "⚽ Sports", "🎲 Surprise me"],
                currentQuestionIndex: 1,
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
                TopicExclusionView()
            }
        }
    }
}

#Preview {
    TopicView()
        .environmentObject(SavedArticlesViewModel())
}
