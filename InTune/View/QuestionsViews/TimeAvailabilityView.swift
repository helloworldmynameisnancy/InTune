//
//  TimeAvailabilityView.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct TimeAvailabilityView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @Environment(\.dismiss) var dismiss
    @State private var goToRecommendations = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            SingleQuestionView(
                question: "How much time do you have to catch up on the news?",
                options: ["⏳ Under 2 minutes", "⏳ 5–10 minutes", "⏳ 10+ minutes", "🕰 Just browsing / no rush"],
                currentQuestionIndex: 3,
                totalQuestions: 4,
                onBack: {
                    dismiss()
                },
                onNext: {
                    withAnimation(.none) {
                        goToRecommendations = true
                    }
                },
                isFinalPage: true
            )
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $goToRecommendations) {
                NewsRecommendationView()
            }
        }
    }

}

#Preview {
    TimeAvailabilityView()
        .environmentObject(SavedArticlesViewModel())
}
