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
    
    init() {
        print("🚀 SavedArticlesViewModel init() - Starting initialization")
        
        // TEMPORARY: Clear all UserDefaults to reset everything (DONT DELETE)
//        UserDefaults.standard.removeObject(forKey: "savedArticleIds")
//        UserDefaults.standard.removeObject(forKey: "shownArticleIds")
//        UserDefaults.standard.removeObject(forKey: "articleQuantity")
//        print("🧹 Cleared all UserDefaults - starting fresh")
        
        // Load persistence data
        loadSavedIds()
        loadMockData()
        
        print("🚀 Final savedArticleIds: \(savedArticleIds)")
        print("🚀 Final savedArticles titles: \(savedArticles.map { $0.displayTitle })")
    }
    
    private func loadMockData() {
        print("📚 loadMockData() - Starting to load mock data")
        
        // Load only recommended articles (mock data removed)
        let allArticles = Article.recommendedArticles
        
        print("📚 All available articles count: \(allArticles.count)")
        
        // If no saved IDs from UserDefaults, start with empty saved articles
        if savedArticleIds.isEmpty {
            print("📚 No saved IDs from UserDefaults, starting with empty saved articles")
            savedArticleIds = Set<String>()
            print("📚 Set empty savedArticleIds count: \(savedArticleIds.count)")
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
    
    // MARK: - Reset Methods
    
    func resetAndSaveAllArticles() {
        print("🔄 Resetting and saving all articles")
        
        // Clear current saved data
        savedArticleIds.removeAll()
        savedArticles.removeAll()
        
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "savedArticleIds")
        
        // Get all available articles from recommendations
        let allArticles = Article.recommendedArticles
        
        // Save all articles
        for article in allArticles {
            savedArticleIds.insert(article.id)
            savedArticles.append(article)
        }
        
        // Save to UserDefaults
        saveToUserDefaults()
        
        print("🔄 Reset complete - saved \(savedArticles.count) articles")
        print("🔄 Saved article IDs: \(Array(savedArticleIds))")
        print("🔄 Saved article titles: \(savedArticles.map { $0.displayTitle })")
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
