//
//  ContentView.swift
//  InTune
//
//  Created by Nancy Luu on 10/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var sharedSavedViewModel = SavedArticlesViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            NewsRecommendationView(savedViewModel: $sharedSavedViewModel)
                .tabItem {
                    Label("Recommendations", systemImage: "star.circle")
                }
            SavedArticlesView(viewModel: $sharedSavedViewModel)
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .tint(Color("MainColor"))
    }
}

#Preview {
    ContentView()
}
