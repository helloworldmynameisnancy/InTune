//
//  TopicExclusionView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct TopicExclusionView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @EnvironmentObject var sessionPreferences: SessionPreferences
    @Binding var path: NavigationPath
    @State private var selectedIndices: Set<Int> = []
    
    private let options = [
        "❌ Health & Disease",
        "❌ Politics",
        "❌ Crime",
        "❌ Celebrity gossip",
        "🚫 No filters"
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            SingleQuestionView(
                question: "Anything you want to skip this time?",
                options: options,
                currentQuestionIndex: 2,
                totalQuestions: 4,
                onBack: {
                    path.removeLast()
                },
                onNext: {
                    // Save selected exclusions in session preferences
                    let selectedOptions = selectedIndices.map { options[$0] }
                    if selectedOptions.contains("🚫 No filters") {
                        sessionPreferences.topicExclusions = []
                    } else {
                        sessionPreferences.topicExclusions = selectedOptions
                    }
                    
                    // Navigate to the next screen
                    withAnimation(.none) {
                        path.append(Screen.timeAvailability)
                    }
                },
                isFinalPage: false,
                enforceSingleSelection: false,
                singleSelectedIndex: .constant(nil),
                disableOthersIfSelected: ["🚫 No filters"]
            )
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    TopicExclusionView(path: .constant(NavigationPath()))
        .environmentObject(SavedArticlesViewModel())
        .environmentObject(SessionPreferences())
}
