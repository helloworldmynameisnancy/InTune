//
//  HomeView.swift
//  
//
//  Created by Nancy Luu on 10/26/25.
//

import SwiftUI

enum Screen: Hashable {
    case mood
    case moodReset
    case topic
    case topicExclusion
    case timeAvailability
    case newsRecommendation
}

struct HomeView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @EnvironmentObject var sessionPreferences: SessionPreferences
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                BackgroundView()

                VStack {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 187, height: 231)

                    Text("ꙆᥒƮᥙᥒᥱ")
                        .font(.system(size: 50))
                        .padding(.top, -20)

                    Text("News curated just for you.")
                        .font(.system(size: 16))
                        .padding(.top, 1)
                        .padding(.bottom, 30)

                    // MAIN BUTTON
                    Button {
                        path.append(Screen.mood)
                    } label: {
                        Text("Tune Me In")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                            .padding()
                            .padding(.horizontal, 75)
                            .background(Color("MainColor"))
                            .cornerRadius(20)
                    }
                }
            }
            // Navigation destinations
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .mood:
                    MoodView(path: $path, resetSelection: false)
                case .moodReset:
                    MoodView(path: $path, resetSelection: true)
                case .topic:
                    TopicView(path: $path)
                case .topicExclusion:
                    TopicExclusionView(path: $path)
                case .timeAvailability:
                    TimeAvailabilityView(path: $path)
                case .newsRecommendation:
                    NewsRecommendationView(path: $path)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SavedArticlesViewModel())
        .environmentObject(SessionPreferences())
}
