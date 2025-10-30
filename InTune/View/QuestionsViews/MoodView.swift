//
//  MoodView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct MoodView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @Environment(\.dismiss) var dismiss
    @State private var goNext = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            SingleQuestionView(
                question: "How are you feeling right now?",
                options: ["😊 Happy / Positive", "😐 Neutral / Just browsing", "😟 Anxious / Worried", "🤔 Curious / Interested", "😴 Tired / Low energy"],
                currentQuestionIndex: 0,
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
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goNext) {
            TopicView()
        }
    }
}

#Preview {
    MoodView()
        .environmentObject(SavedArticlesViewModel())
}
