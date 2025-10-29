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
        
        // Auto-load initial articles
        regenerateArticles()
        
    }
    
    // MARK: - Public Methods
    
    func regenerateArticles() {
        let selectedArticles = selectRandomArticles(count: articleQuantity)
        displayedArticles = selectedArticles
    }
    
    func updateQuantity(_ newQuantity: Int) {
        
        guard newQuantity >= Constants.minQuantity && newQuantity <= Constants.maxQuantity else {
            return
        }
        
        articleQuantity = newQuantity
        saveArticleQuantity()
        
    }
    
    // MARK: - Private Methods
    
    // temporary
    private func selectRandomArticles(count: Int) -> [Article] {
        
        // Get available articles (not yet shown)
        var availableArticles = Article.recommendedArticles.filter { !shownArticleIds.contains($0.id) }
        
        // Check if we need to reset (all articles shown)
        if availableArticles.count < count {
            resetShownIdsIfAllArticlesShown()
            // Re-filter after potential reset
            availableArticles = Article.recommendedArticles.filter { !shownArticleIds.contains($0.id) }
        }
        
        // Use filtered articles
        let finalAvailable = availableArticles
        
        // Select random articles
        let selectedCount = min(count, finalAvailable.count)
        let shuffled = finalAvailable.shuffled()
        let selected = Array(shuffled.prefix(selectedCount))
        
        // Add selected IDs to shown set
        for article in selected {
            shownArticleIds.insert(article.id)
        }
        
        // Save updated shown IDs
        saveShownArticleIds()
        
        return selected
    }
    
    private func resetShownIdsIfAllArticlesShown() {
        
        let totalArticles = Article.recommendedArticles.count
        let shownCount = shownArticleIds.count
        
        
        if shownCount >= totalArticles {
            shownArticleIds.removeAll()
            saveShownArticleIds()
        }
    }
    
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
