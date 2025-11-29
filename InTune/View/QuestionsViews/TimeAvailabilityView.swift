//
//  TimeAvailabilityView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct TimeAvailabilityView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @EnvironmentObject var sessionPreferences: SessionPreferences
    @Binding var path: NavigationPath
    @State private var selectedTimeIndex: Int? = nil
    
    var resetSelection: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            SingleQuestionView(
                question: "How much time do you have to catch up on the news?",
                options: [
                    "⏳ Under 2 minutes",
                    "⏳ 5–10 minutes",
                    "⏳ 10+ minutes",
                    "🕰 Just browsing / no rush"
                ],
                currentQuestionIndex: 3,
                totalQuestions: 4,
                onBack: {
                    path.removeLast()
                },
                onNext: {
                    // Save selected time to session preferences
                    if let index = selectedTimeIndex {
                        sessionPreferences.timeAvailability = [
                            "⏳ Under 2 minutes",
                            "⏳ 5–10 minutes",
                            "⏳ 10+ minutes",
                            "🕰 Just browsing / no rush"
                        ][index]
                    }
                    
                    // Navigate to news recommendation screen
                    withAnimation(.none) {
                        path.append(Screen.newsRecommendation)
                    }
                },
                isFinalPage: true,
                enforceSingleSelection: true,
                singleSelectedIndex: $selectedTimeIndex
            )
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            if resetSelection {
                selectedTimeIndex = nil
            }
        }
    }
}

#Preview {
    TimeAvailabilityView(path: .constant(NavigationPath()))
        .environmentObject(SavedArticlesViewModel())
        .environmentObject(SessionPreferences())
}
