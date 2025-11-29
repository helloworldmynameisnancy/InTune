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

                    // MAIN BUTTON — now styled AND complete
                    Button("Tune Me In") {
                        path.append(Screen.mood)
                    
                    // TEMPORARY: API Test Button (remove after testing)
                    Button {
                        Task {
                            let service = NewsAPIAIService()
                            do {
                                let success = try await service.testConnection()
                                print(success ? "\n✅✅✅ API TEST SUCCESSFUL! ✅✅✅\n" : "\n❌❌❌ API TEST FAILED ❌❌❌\n")
                            } catch {
                                print("\n❌❌❌ API TEST ERROR: \(error.localizedDescription) ❌❌❌\n")
                            }
                        }
                    } label: {
                        Text("🧪 Test API Connection")
                            .font(.system(size: 14))
                            .foregroundStyle(.blue)
                            .padding(.top, 10)
                    }
                            }
                        }
                    } label: {
                        Text("🧪 Test API Connection")
                            .font(.system(size: 14))
                            .foregroundStyle(.blue)
                            .padding(.top, 10)
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
        // AUTO API CHECK ON LAUNCH
        .onAppear {
            Task {
                print("\n🚀 Starting API connection test...\n")
                let service = NewsAPIAIService()
                do {
                    let success = try await service.testConnection()
                    print(success ? "\n✅ API TEST SUCCESSFUL\n" : "\n❌ API TEST FAILED\n")
                } catch {
                    print("\n❌ API TEST ERROR: \(error.localizedDescription)\n")
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SavedArticlesViewModel())
}
