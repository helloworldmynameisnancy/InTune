//
//  ContentView.swift
//  InTune
//
//  Created by Nancy Luu on 10/20/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SavedView()
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
