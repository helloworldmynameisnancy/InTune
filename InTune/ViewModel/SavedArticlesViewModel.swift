//
//  SavedArticlesViewModel.swift
//  InTune
//
//  Created by Diana Nguyen on 10/27/25.
//

import Foundation
import SwiftUI

@Observable
class SavedArticlesViewModel {
    var savedArticles: [Article] = []
    private var savedArticleIds: Set<String> = []
    
    init() {
        print("🚀 SavedArticlesViewModel init() - Starting initialization")
        
        // One-time cleanup: Clear old UUID-based data (remove this after first successful run)
        // clearOldUserDefaultsData()  // ← REMOVED: This was clearing saved data on every launch
        
        // Load saved article IDs from UserDefaults first
        loadSavedIds()
        print("🚀 After loadSavedIds() - savedArticleIds count: \(savedArticleIds.count)")
        // Then load mock data (will merge with persisted state)
        loadMockData()
        print("🚀 After loadMockData() - savedArticles count: \(savedArticles.count)")
        print("🚀 Final savedArticleIds: \(savedArticleIds)")
        print("🚀 Final savedArticles titles: \(savedArticles.map { $0.displayTitle })")
    }
    
    private func loadMockData() {
        print("📚 loadMockData() - Starting to load mock data")
        // Load all available articles
        let allArticles = [
            Article.mockArticle1,
            Article.mockArticle2,
            Article.mockArticle3,
            Article.mockArticle4,
            Article.mockArticle5,
            Article.mockArticle6,
            Article.mockArticle7
        ]
        print("📚 All available articles count: \(allArticles.count)")
        
        // If no saved IDs from UserDefaults, start with some articles saved (for demo)
        if savedArticleIds.isEmpty {
            print("📚 No saved IDs from UserDefaults, using demo data")
            let initiallySavedIds: Set<String> = [
                Article.mockArticle2.id,
                Article.mockArticle3.id,
                Article.mockArticle4.id,
                Article.mockArticle5.id,
                Article.mockArticle6.id,
                Article.mockArticle7.id
            ]
            savedArticleIds = initiallySavedIds
            print("📚 Set demo savedArticleIds count: \(savedArticleIds.count)")
        } else {
            print("📚 Using persisted savedArticleIds count: \(savedArticleIds.count)")
        }
        
        // Filter articles to only include those with IDs in saved set
        savedArticles = allArticles.filter { savedArticleIds.contains($0.id) }
        print("📚 Filtered savedArticles count: \(savedArticles.count)")
        print("📚 Saved article titles: \(savedArticles.map { $0.displayTitle })")
    }
    
    func toggleBookmark(for article: Article) {
        print("🔖 toggleBookmark() - Starting toggle for: \(article.displayTitle)")
        print("🔖 Before toggle - savedArticles count: \(savedArticles.count)")
        print("🔖 Before toggle - savedArticleIds count: \(savedArticleIds.count)")
        
        if savedArticleIds.contains(article.id) {
            // Remove from saved
            print("🔖 Removing article from saved list")
            savedArticleIds.remove(article.id)
            savedArticles.removeAll { $0.id == article.id }
            print("🔖 After removal - savedArticles count: \(savedArticles.count)")
            print("🔖 After removal - savedArticleIds count: \(savedArticleIds.count)")
        } else {
            // Add to saved
            print("🔖 Adding article to saved list")
            savedArticleIds.insert(article.id)
            savedArticles.append(article)
            print("🔖 After addition - savedArticles count: \(savedArticles.count)")
            print("🔖 After addition - savedArticleIds count: \(savedArticleIds.count)")
        }
        
        // Save changes to UserDefaults
        print("🔖 Saving changes to UserDefaults")
        saveToUserDefaults()
        
        print("🔖 Final savedArticleIds: \(savedArticleIds)")
        print("🔖 Final savedArticles titles: \(savedArticles.map { $0.displayTitle })")
        print("🔖 toggleBookmark() - Completed")
    }
    
    func addArticle(_ article: Article) {
        // Add article to saved list (for future use)
        if !savedArticleIds.contains(article.id) {
            savedArticleIds.insert(article.id)
            savedArticles.append(article)
        }
    }
    
    func isArticleSaved(_ article: Article) -> Bool {
        return savedArticleIds.contains(article.id)
    }
    
    // MARK: - Persistence Methods
    
    private func clearOldUserDefaultsData() {
        print("🧹 clearOldUserDefaultsData() - Clearing old UUID-based data")
        // Clear the old "savedArticleIds" key that contains UUIDs
        UserDefaults.standard.removeObject(forKey: "savedArticleIds")
        print("🧹 Cleared old UserDefaults data - starting fresh with URL-based IDs")
    }
    
    private func loadSavedIds() {
        print("💾 loadSavedIds() - Loading from UserDefaults")
        // Load saved article IDs from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "savedArticleIds"),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            savedArticleIds = Set(ids)
            print("💾 Successfully loaded \(ids.count) saved IDs from UserDefaults")
            print("💾 Loaded IDs: \(ids)")
        } else {
            print("💾 No saved data found in UserDefaults or data is corrupted")
        }
    }
    
    private func saveToUserDefaults() {
        print("💾 saveToUserDefaults() - Saving to UserDefaults")
        // Save saved article IDs to UserDefaults
        if let data = try? JSONEncoder().encode(Array(savedArticleIds)) {
            UserDefaults.standard.set(data, forKey: "savedArticleIds")
            print("💾 Successfully saved \(savedArticleIds.count) IDs to UserDefaults")
            print("💾 Saved IDs: \(Array(savedArticleIds))")
        } else {
            print("💾 Failed to encode data for UserDefaults")
        }
    }
}
