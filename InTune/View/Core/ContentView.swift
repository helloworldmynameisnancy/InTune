//
//  ContentView.swift
//  InTune
//
//  Created by Nancy Luu on 10/20/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @EnvironmentObject var sessionPreferences: SessionPreferences
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SavedArticlesView()
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
        .environmentObject(SavedArticlesViewModel())
        .environmentObject(SessionPreferences())
}
