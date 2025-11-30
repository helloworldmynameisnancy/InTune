//
//  RecommendationViewModel.swift
//  InTune
//
//  Created by Diana Nguyen on 10/28/25.
//

import Foundation
import SwiftUI

@Observable
class RecommendationViewModel {
    var displayedArticles: [Article] = []
    private var shownArticleIds: Set<String> = []
    var articleQuantity: Int = Constants.defaultQuantity
    
    // API Integration Properties
    private let apiService = NewsAPIAIService()
    private var allFetchedArticles: [Article] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var allArticlesShown: Bool = false
    
    private enum UserDefaultsKeys {
        static let shownRecommendationIds = "shownRecommendationIds"
        static let recommendationQuantity = "recommendationQuantity"
    }
    
    // Article Quantity Setter
    private enum Constants {
        static let minQuantity = 3
        static let maxQuantity = 5
        static let defaultQuantity = 4
    }
    
    init() {
        // Load persistence data
        loadShownArticleIds()
        loadArticleQuantity()
        
        // Note: Articles will be fetched via fetchArticles() when view appears
    }
    
    // MARK: - Public Methods
    
    /// Fetches 100 articles from API using session preferences
    func fetchArticles(preferences: SessionPreferences) async {
        print("🟢 [RecommendationViewModel] Preferences - Mood: \(preferences.mood), Topics: \(preferences.topics), Exclusions: \(preferences.topicExclusions.count)")
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
            allArticlesShown = false
        }
        
        do {
            let articles = try await apiService.fetchArticles(preferences: preferences, count: 100)
            
            print("🟢 [RecommendationViewModel] Received \(articles.count) articles from API")
            
            await MainActor.run {
                allFetchedArticles = articles
                shownArticleIds.removeAll()  // Reset shown IDs for new fetch
                isLoading = false
                regenerateArticles()  // Show first batch
            }
        } catch {
            print("❌ [RecommendationViewModel] Error fetching articles: \(error)")
            print("❌ [RecommendationViewModel] Error description: \(error.localizedDescription)")
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func regenerateArticles() {
        // Check if all articles have been shown
        if allArticlesShown {
            displayedArticles = []
            return
        }
        
        // Check if we've shown all fetched articles
        if shownArticleIds.count >= allFetchedArticles.count {
            allArticlesShown = true
            displayedArticles = []
            saveShownArticleIds()
            return
        }
        
        // Get unseen articles from fetched articles
        let unseenArticles = allFetchedArticles.filter { !shownArticleIds.contains($0.id) }
        
        // NOTE: Reading time filtering will be added by partner later
        // For now, use all unseen articles
        
        // Select random articles from unseen pool
        let selectedCount = min(articleQuantity, unseenArticles.count)
        let shuffled = unseenArticles.shuffled()
        let selected = Array(shuffled.prefix(selectedCount))
        
        // Mark selected as shown
        for article in selected {
            shownArticleIds.insert(article.id)
        }
        
        // Update displayed articles
        displayedArticles = selected
        
        // Save shown IDs
        saveShownArticleIds()
        
        // Check if we've now shown all articles
        if shownArticleIds.count >= allFetchedArticles.count {
            allArticlesShown = true
        }
    }
    
    /// Resets and refetches articles with new preferences
    func resetAndRefetch(preferences: SessionPreferences) async {
        await MainActor.run {
            allFetchedArticles.removeAll()
            shownArticleIds.removeAll()
            allArticlesShown = false
            displayedArticles = []
        }
        
        await fetchArticles(preferences: preferences)
    }
    
    func updateQuantity(_ newQuantity: Int) {
        
        guard newQuantity >= Constants.minQuantity && newQuantity <= Constants.maxQuantity else {
            return
        }
        
        articleQuantity = newQuantity
        saveArticleQuantity()
        
    }
    
    // MARK: - Private Methods
    // Note: selectRandomArticles() and resetShownIdsIfAllArticlesShown() removed
    // Logic now handled directly in regenerateArticles() using allFetchedArticles
    
    // MARK: - Persistence Methods
    
    private func loadShownArticleIds() {
        // Load shown article IDs from UserDefaults
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.shownRecommendationIds),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            shownArticleIds = Set(ids)
        } else {
            print("RecommendationViewModel - No shown article IDs found in UserDefaults or failed to decode")
        }
    }
    
    private func loadArticleQuantity() {
        // Load quantity preference from UserDefaults
        let savedQuantity = UserDefaults.standard.integer(forKey: UserDefaultsKeys.recommendationQuantity)
        if savedQuantity >= Constants.minQuantity && savedQuantity <= Constants.maxQuantity {
            articleQuantity = savedQuantity
        }
    }
    
    private func saveShownArticleIds() {
        
        if let data = try? JSONEncoder().encode(Array(shownArticleIds)) {
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.shownRecommendationIds)
        } else {
            print("RecommendationViewModel - Failed to encode shown article IDs for UserDefaults")
        }
    }
    
    private func saveArticleQuantity() {
        
        UserDefaults.standard.set(articleQuantity, forKey: UserDefaultsKeys.recommendationQuantity)
    }
}
