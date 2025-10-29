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
    var articleQuantity: Int = 4
    
    private enum UserDefaultsKeys {
        static let shownRecommendationIds = "shownRecommendationIds"
        static let recommendationQuantity = "recommendationQuantity"
    }
    
    init() {
        
        // Load persistence data
        loadPreferences()
        
        // Auto-load initial articles
        loadInitialArticles()
        
    }
    
    // MARK: - Public Methods
    
    func loadInitialArticles() {
        regenerateArticles()
    }
    
    func regenerateArticles() {
        let selectedArticles = selectRandomArticles(count: articleQuantity)
        displayedArticles = selectedArticles
    }
    
    func updateQuantity(_ newQuantity: Int) {
        
        guard newQuantity >= 3 && newQuantity <= 5 else {
            return
        }
        
        articleQuantity = newQuantity
        saveQuantity()
        
    }
    
    // MARK: - Private Methods
    
    private func selectRandomArticles(count: Int) -> [Article] {
        
        // Get available articles (not yet shown)
        let availableArticles = Article.recommendedArticles.filter { !shownArticleIds.contains($0.id) }
        
        // Check if we need to reset (all articles shown)
        if availableArticles.count < count {
            checkAndResetIfNeeded()
        }
        
        // Get final available articles
        let finalAvailable = Article.recommendedArticles.filter { !shownArticleIds.contains($0.id) }
        
        // Select random articles
        let selectedCount = min(count, finalAvailable.count)
        let shuffled = finalAvailable.shuffled()
        let selected = Array(shuffled.prefix(selectedCount))
        
        // Add selected IDs to shown set
        for article in selected {
            shownArticleIds.insert(article.id)
        }
        
        // Save updated shown IDs
        saveShownIds()
        
        return selected
    }
    
    private func checkAndResetIfNeeded() {
        
        let totalArticles = Article.recommendedArticles.count
        let shownCount = shownArticleIds.count
        
        
        if shownCount >= totalArticles {
            shownArticleIds.removeAll()
            saveShownIds()
        }
    }
    
    // MARK: - Persistence Methods
    
    private func loadPreferences() {
        
        // Load shown article IDs
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.shownRecommendationIds),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            shownArticleIds = Set(ids)
        } else {
        }
        
        // Load quantity preference
        let savedQuantity = UserDefaults.standard.integer(forKey: UserDefaultsKeys.recommendationQuantity)
        if savedQuantity >= 3 && savedQuantity <= 5 {
            articleQuantity = savedQuantity
        } else {
        }
    }
    
    private func saveShownIds() {
        
        if let data = try? JSONEncoder().encode(Array(shownArticleIds)) {
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.shownRecommendationIds)
        } else {
        }
    }
    
    private func saveQuantity() {
        
        UserDefaults.standard.set(articleQuantity, forKey: UserDefaultsKeys.recommendationQuantity)
    }
}
