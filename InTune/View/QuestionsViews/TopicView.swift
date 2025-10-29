//
//  TopicView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct TopicView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @State private var goBack = false
    @State private var goNext = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                SingleQuestionView(
                    question: "What topics interest you at the moment?",
                    options: ["💻 Technology", "🏛 Politics", "🌍 World news", "🎨 Arts & Culture", "🩺 Health", "⚽ Sports", "🎲 Surprise me"],
                    currentQuestionIndex: 1,
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
                    TopicExclusionView()
                }
                .navigationDestination(isPresented: $goBack) {
                    MoodView()
                }
            }
        }
    }
}

#Preview {
    TopicView()
        .environmentObject(SavedArticlesViewModel())
}
