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
        loadSavedIds()
        loadMockData()
    }
    
    private func loadMockData() {
        
        // Load only recommended articles (mock data removed)
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
        saveToUserDefaults()
        
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
        
        // Clear current saved data
        savedArticleIds.removeAll()
        savedArticles.removeAll()
        
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.savedArticleIds)
        
        // Get all available articles from recommendations
        let allArticles = Article.recommendedArticles
        
        // Save all articles
        for article in allArticles {
            savedArticleIds.insert(article.id)
            savedArticles.append(article)
        }
        
        // Save to UserDefaults
        saveToUserDefaults()
        
    }
    
    // MARK: - Persistence Methods
    
    private func loadSavedIds() {
        // Load saved article IDs from UserDefaults
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.savedArticleIds),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            savedArticleIds = Set(ids)
        }
    }
    
    private func saveToUserDefaults() {
        // Save saved article IDs to UserDefaults
        if let data = try? JSONEncoder().encode(Array(savedArticleIds)) {
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.savedArticleIds)
        }
    }
}
