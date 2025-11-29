//
//  InTuneApp.swift
//  InTune
//
//  Created by Nancy Luu on 10/20/25.
//

import SwiftUI

@main
struct InTuneApp: App {
    @StateObject var savedViewModel = SavedArticlesViewModel()
    @StateObject var sessionPreferences = SessionPreferences()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(savedViewModel)
                .environmentObject(sessionPreferences)
        }
    }
}
