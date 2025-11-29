//
//  MoodView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct MoodView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @EnvironmentObject var sessionPreferences: SessionPreferences
    @Binding var path: NavigationPath
    @State private var selectedMoodIndex: Int? = nil
    
    private let moodOptions = [
        "😊 Happy / Positive",
        "😐 Neutral / Just browsing",
        "😟 Anxious / Worried",
        "🤔 Curious / Interested",
        "😴 Tired / Low energy"
    ]
    
    var resetSelection: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            SingleQuestionView(
                question: "How are you feeling right now?",
                options: moodOptions,
                currentQuestionIndex: 0,
                totalQuestions: 4,
                onBack: {
                    path.removeLast()
                },
                onNext: {
                    // Save selection in session preferences
                    if let index = selectedMoodIndex {
                        sessionPreferences.mood = moodOptions[index]
                    }
                    
                    // Navigate to next screen
                    withAnimation(.none) {
                        path.append(Screen.topic)
                    }
                },
                isFinalPage: false,
                enforceSingleSelection: true,
                singleSelectedIndex: $selectedMoodIndex
            )
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if resetSelection {
                selectedMoodIndex = nil
            }
        }
    }
}

#Preview {
    MoodView(path: .constant(NavigationPath()))
        .environmentObject(SavedArticlesViewModel())
        .environmentObject(SessionPreferences())
}
