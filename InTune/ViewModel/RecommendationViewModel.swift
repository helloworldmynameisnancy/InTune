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
    
    init() {
        print("🎯 RecommendationViewModel init() - Starting initialization")
        
        // Load persistence data
        loadPreferences()
        
        // Auto-load initial articles
        loadInitialArticles()
        
        print("🎯 Final displayedArticles count: \(displayedArticles.count)")
        print("🎯 Final shownArticleIds count: \(shownArticleIds.count)")
        print("🎯 Final articleQuantity: \(articleQuantity)")
    }
    
    // MARK: - Public Methods
    
    func loadInitialArticles() {
        print("🎯 loadInitialArticles() - Loading initial random articles")
        regenerateArticles()
    }
    
    func regenerateArticles() {
        print("🎯 regenerateArticles() - Generating \(articleQuantity) new articles")
        
        let selectedArticles = selectRandomArticles(count: articleQuantity)
        displayedArticles = selectedArticles
        
        print("🎯 Selected \(selectedArticles.count) articles:")
        for article in selectedArticles {
            print("🎯 - \(article.displayTitle)")
        }
    }
    
    func updateQuantity(_ newQuantity: Int) {
        print("🎯 updateQuantity() - Updating from \(articleQuantity) to \(newQuantity)")
        
        guard newQuantity >= 3 && newQuantity <= 5 else {
            print("🎯 Invalid quantity \(newQuantity), keeping current: \(articleQuantity)")
            return
        }
        
        articleQuantity = newQuantity
        saveQuantity()
        
        print("🎯 Quantity updated to \(articleQuantity)")
    }
    
    // MARK: - Private Methods
    
    private func selectRandomArticles(count: Int) -> [Article] {
        print("🎯 selectRandomArticles() - Selecting \(count) articles")
        
        // Get available articles (not yet shown)
        let availableArticles = Article.recommendedArticles.filter { !shownArticleIds.contains($0.id) }
        print("🎯 Available articles count: \(availableArticles.count)")
        
        // Check if we need to reset (all articles shown)
        if availableArticles.count < count {
            print("🎯 Not enough available articles, checking if reset needed")
            checkAndResetIfNeeded()
            
            // Re-filter after potential reset
            let refreshedAvailable = Article.recommendedArticles.filter { !shownArticleIds.contains($0.id) }
            print("🎯 After reset check - available articles count: \(refreshedAvailable.count)")
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
        
        print("🎯 Selected \(selected.count) articles, total shown: \(shownArticleIds.count)")
        return selected
    }
    
    private func checkAndResetIfNeeded() {
        print("🎯 checkAndResetIfNeeded() - Checking if all articles have been shown")
        
        let totalArticles = Article.recommendedArticles.count
        let shownCount = shownArticleIds.count
        
        print("🎯 Total articles: \(totalArticles), Shown: \(shownCount)")
        
        if shownCount >= totalArticles {
            print("🎯 All articles have been shown, resetting exclusion list")
            shownArticleIds.removeAll()
            saveShownIds()
            print("🎯 Exclusion list reset - ready for new cycle")
        }
    }
    
    // MARK: - Persistence Methods
    
    private func loadPreferences() {
        print("🎯 loadPreferences() - Loading from UserDefaults")
        
        // Load shown article IDs
        if let data = UserDefaults.standard.data(forKey: "shownRecommendationIds"),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            shownArticleIds = Set(ids)
            print("🎯 Successfully loaded \(ids.count) shown IDs from UserDefaults")
        } else {
            print("🎯 No shown IDs found in UserDefaults, starting fresh")
        }
        
        // Load quantity preference
        let savedQuantity = UserDefaults.standard.integer(forKey: "recommendationQuantity")
        if savedQuantity >= 3 && savedQuantity <= 5 {
            articleQuantity = savedQuantity
            print("🎯 Loaded quantity preference: \(articleQuantity)")
        } else {
            print("🎯 No valid quantity preference found, using default: \(articleQuantity)")
        }
    }
    
    private func saveShownIds() {
        print("🎯 saveShownIds() - Saving to UserDefaults")
        
        if let data = try? JSONEncoder().encode(Array(shownArticleIds)) {
            UserDefaults.standard.set(data, forKey: "shownRecommendationIds")
            print("🎯 Successfully saved \(shownArticleIds.count) shown IDs to UserDefaults")
        } else {
            print("🎯 Failed to encode shown IDs for UserDefaults")
        }
    }
    
    private func saveQuantity() {
        print("🎯 saveQuantity() - Saving to UserDefaults")
        
        UserDefaults.standard.set(articleQuantity, forKey: "recommendationQuantity")
        print("🎯 Successfully saved quantity \(articleQuantity) to UserDefaults")
    }
}
