//
//  TopicView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct TopicView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @EnvironmentObject var sessionPreferences: SessionPreferences
    @Binding var path: NavigationPath
    @State private var selectedIndices: Set<Int> = []
    
    private let options = [
        "💻 Technology",
        "💼 Business",
        "🏛 Politics",
        "🩺 Health",
        "⚽ Sports",
        "🔬 Science",
        "🎲 Surprise me"
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            SingleQuestionView(
                question: "What topics interest you at the moment?",
                options: options,
                currentQuestionIndex: 1,
                totalQuestions: 4,
                onBack: {
                    path.removeLast()
                },
                onNext: {
                    // Save selected topics in session preferences
                    let selectedOptions = selectedIndices.map { options[$0] }
                    if selectedOptions.contains("🎲 Surprise Me") {
                        // "Surprise Me" overrides all other selections
                        sessionPreferences.topics = ["🎲 Surprise me"]
                    } else {
                        sessionPreferences.topics = selectedOptions
                    }
                    
                    // Navigate to next screen - defer to next run loop to avoid AttributeGraph error
                    Task { @MainActor in
                        path.append(Screen.topicExclusion)
                    }
                },
                isFinalPage: false,
                enforceSingleSelection: false,
                singleSelectedIndex: .constant(nil),
                selectedIndicesBinding: $selectedIndices,
                disableOthersIfSelected: ["🎲 Surprise me"]
            )
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    TopicView(path: .constant(NavigationPath()))
        .environmentObject(SavedArticlesViewModel())
        .environmentObject(SessionPreferences())
}
