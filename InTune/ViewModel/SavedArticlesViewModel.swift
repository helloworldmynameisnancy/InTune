//
//  SavedArticlesViewModel.swift
//  InTune
//
//  Created by Diana Nguyen on 10/27/25.
//

import Foundation
import SwiftUI
import Combine

class SavedArticlesViewModel: ObservableObject {
    @Published var savedArticles: [Article] = []
    
    private enum UserDefaultsKeys {
        static let savedArticles = "savedArticles"
        static let savedArticleIds = "savedArticleIds" // Old key - will be cleared on first run
    }
    
    init() {
        // ⚠️ TEMPORARY: Clear old UserDefaults key on first run after this change
        // ⚠️ COMMENT THIS LINE BACK AFTER THE FIRST RUN (line 23)
        // UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.savedArticleIds)
        
        // Load persistence data
        loadSavedArticles()
    }
    
    func toggleBookmark(for article: Article) {
        if savedArticles.contains(where: { $0.id == article.id }) {
            // Remove from saved
            savedArticles.removeAll { $0.id == article.id }
        } else {
            // Add to saved
            savedArticles.append(article)
        }
        
        // Save changes to UserDefaults
        saveSavedArticles()
    }
    
    func isArticleSaved(_ article: Article) -> Bool {
        return savedArticles.contains(where: { $0.id == article.id })
    }
    
    // MARK: - Persistence Methods
    
    private func loadSavedArticles() {
        // Load full saved articles from UserDefaults
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.savedArticles),
           let articles = try? JSONDecoder().decode([Article].self, from: data) {
            savedArticles = articles
            print("✅ SavedArticlesViewModel - Loaded \(articles.count) saved articles from UserDefaults")
        } else {
            print("ℹ️ SavedArticlesViewModel - No saved articles found in UserDefaults or failed to decode")
        }
    }
    
    private func saveSavedArticles() {
        // Save full saved articles to UserDefaults
        if let data = try? JSONEncoder().encode(savedArticles) {
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.savedArticles)
            print("✅ SavedArticlesViewModel - Saved \(savedArticles.count) articles to UserDefaults")
        } else {
            print("⚠️ SavedArticlesViewModel - Failed to encode saved articles for UserDefaults")
        }
    }
}
