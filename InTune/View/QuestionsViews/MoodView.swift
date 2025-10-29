//
//  MoodView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct MoodView: View {
    @Binding var savedViewModel: SavedArticlesViewModel
    @State private var goBack = false
    @State private var goNext = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                SingleQuestionView(
                    question: "How are you feeling right now?",
                    options: ["😊 Happy / Positive", "😐 Neutral / Just browsing", "😟 Anxious / Worried", "🤔 Curious / Interested", "😴 Tired / Low energy"],
                    currentQuestionIndex: 0,
                    totalQuestions: 4,
                    onBack: {
                        goBack = true
                    },
                    onNext: {
                        goNext = true
                    },
                    isFinalPage: false
                )
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $goNext) {
                TopicView(savedViewModel: $savedViewModel)
            }
            .navigationDestination(isPresented: $goBack) {
                HomeView(savedViewModel: $savedViewModel)
            }
        }
        
    }
}

#Preview {
    @State var previewSavedViewModel = SavedArticlesViewModel()
    return MoodView(savedViewModel: $previewSavedViewModel)
}
