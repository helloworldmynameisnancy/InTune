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
    @State private var selectedIndex: Int? = nil
    
    private let options = [
        "❌ Health & Disease",
        "❌ Politics",
        "❌ Violence",
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
                    // Save selected exclusion in session preferences (single selection only)
                    if let index = selectedIndex {
                        let selectedOption = options[index]
                        if selectedOption == "🚫 No filters" {
                            sessionPreferences.topicExclusions = []
                        } else {
                            sessionPreferences.topicExclusions = [selectedOption]
                        }
                    } else {
                        sessionPreferences.topicExclusions = []
                    }
                    
                    // Navigate to the next screen - defer to next run loop to avoid AttributeGraph error
                    Task { @MainActor in
                        path.append(Screen.timeAvailability)
                    }
                },
                isFinalPage: false,
                enforceSingleSelection: true,
                singleSelectedIndex: $selectedIndex,
                selectedIndicesBinding: nil,
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
