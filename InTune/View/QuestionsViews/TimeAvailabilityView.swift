//
//  TimeAvailabilityView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct TimeAvailabilityView: View {
    @Binding var savedViewModel: SavedArticlesViewModel
    @State private var goBack = false
    @State private var goToRecommendations = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                SingleQuestionView(
                    question: "How much time do you have to catch up on the news?",
                    options: ["⏳ Under 2 minutes", "⏳ 5–10 minutes", "⏳ 10+ minutes", "🕰 Just browsing / no rush"],
                    currentQuestionIndex: 3,
                    totalQuestions: 4,
                    onBack: {
                        goBack = true
                    },
                    onNext: {
                        print("Generate News tapped!")
                        goToRecommendations = true
                    },
                    isFinalPage: true
                )
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $goBack) {
                    TopicExclusionView(savedViewModel: $savedViewModel)
                }
                .navigationDestination(isPresented: $goToRecommendations) {
                    NewsRecommendationView(savedViewModel: $savedViewModel)
                }
            }
        }
    }
}

#Preview {
    @State var previewSavedViewModel = SavedArticlesViewModel()
    return TimeAvailabilityView(savedViewModel: $previewSavedViewModel)
}
