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
    var noArticlesFound: Bool = false
    
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
        loadShownArticleIds()
        loadArticleQuantity()
    }
    
    // MARK: - Public Methods
    
    /// Fetches 100 articles from API using session preferences
    func fetchArticles(preferences: SessionPreferences) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
            allArticlesShown = false
            noArticlesFound = false
        }
        
        do {
            let articles = try await apiService.fetchArticles(preferences: preferences, count: 100)
            
            await MainActor.run {
                allFetchedArticles = articles
                shownArticleIds.removeAll()
                noArticlesFound = articles.isEmpty || articles.count <= articleQuantity
                isLoading = false
                if !articles.isEmpty && articles.count > articleQuantity {
                    regenerateArticles()
                } else {
                    displayedArticles = []
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func regenerateArticles() {
        if allArticlesShown {
            displayedArticles = []
            return
        }
        
        if shownArticleIds.count >= allFetchedArticles.count {
            allArticlesShown = true
            displayedArticles = []
            saveShownArticleIds()
            return
        }
        
        let unseenArticles = allFetchedArticles.filter { !shownArticleIds.contains($0.id) }
        let selectedCount = min(articleQuantity, unseenArticles.count)
        let shuffled = unseenArticles.shuffled()
        let selected = Array(shuffled.prefix(selectedCount))
        
        for article in selected {
            shownArticleIds.insert(article.id)
        }
        
        displayedArticles = selected
        saveShownArticleIds()
    }
    
    func updateQuantity(_ newQuantity: Int) {
        guard newQuantity >= Constants.minQuantity && newQuantity <= Constants.maxQuantity else {
            return
        }
        articleQuantity = newQuantity
        saveArticleQuantity()
    }
    
    // MARK: - Persistence Methods
    
    private func loadShownArticleIds() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.shownRecommendationIds),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            shownArticleIds = Set(ids)
        }
    }
    
    private func loadArticleQuantity() {
        let savedQuantity = UserDefaults.standard.integer(forKey: UserDefaultsKeys.recommendationQuantity)
        if savedQuantity >= Constants.minQuantity && savedQuantity <= Constants.maxQuantity {
            articleQuantity = savedQuantity
        }
    }
    
    private func saveShownArticleIds() {
        if let data = try? JSONEncoder().encode(Array(shownArticleIds)) {
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.shownRecommendationIds)
        }
    }
    
    private func saveArticleQuantity() {
        UserDefaults.standard.set(articleQuantity, forKey: UserDefaultsKeys.recommendationQuantity)
    }
}
