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
    private var savedArticleIds: Set<String> = []
    
    private enum UserDefaultsKeys {
        static let savedArticleIds = "savedArticleIds"
    }
    
    init() {
        // TEMPORARY: Clear all UserDefaults to reset everything (DONT DELETE)
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.savedArticleIds)
//        UserDefaults.standard.removeObject(forKey: "shownArticleIds")
//        UserDefaults.standard.removeObject(forKey: "articleQuantity")
        
        // Load persistence data
        loadSavedArticleIds()
        syncSavedArticles()
    }
    
    private func syncSavedArticles() {
        // Sync savedArticles array with available articles from repository
        // Filters Article.recommendedArticles to only include articles with IDs in savedArticleIds
        let allArticles = Article.recommendedArticles
        
        // Filter articles to only include those with IDs in saved set
        savedArticles = allArticles.filter { savedArticleIds.contains($0.id) }
    }
    
    func toggleBookmark(for article: Article) {
        
        if savedArticleIds.contains(article.id) {
            // Remove from saved
            savedArticleIds.remove(article.id)
            savedArticles.removeAll { $0.id == article.id }
        } else {
            // Add to saved
            savedArticleIds.insert(article.id)
            savedArticles.append(article)
        }
        
        // Save changes to UserDefaults
        saveSavedArticleIds()
        
    }
    
    func isArticleSaved(_ article: Article) -> Bool {
        return savedArticleIds.contains(article.id)
    }
    
    // MARK: - Persistence Methods
    
    private func loadSavedArticleIds() {
        // Load saved article IDs from UserDefaults
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.savedArticleIds),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            savedArticleIds = Set(ids)
        } else {
            print("ℹ️ SavedArticlesViewModel - No saved article IDs found in UserDefaults or failed to decode")
        }
    }
    
    private func saveSavedArticleIds() {
        // Save saved article IDs to UserDefaults
        if let data = try? JSONEncoder().encode(Array(savedArticleIds)) {
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.savedArticleIds)
        } else {
            print("⚠️ SavedArticlesViewModel - Failed to encode saved article IDs for UserDefaults")
        }
    }
}
