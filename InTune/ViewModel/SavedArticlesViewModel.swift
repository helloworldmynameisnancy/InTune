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
    }
    
    init() {
        loadSavedArticles()
    }
    
    func toggleBookmark(for article: Article) {
        if savedArticles.contains(where: { $0.id == article.id }) {
            savedArticles.removeAll { $0.id == article.id }
        } else {
            savedArticles.append(article)
        }
        saveSavedArticles()
    }
    
    func isArticleSaved(_ article: Article) -> Bool {
        return savedArticles.contains(where: { $0.id == article.id })
    }
    
    // MARK: - Persistence Methods
    
    private func loadSavedArticles() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.savedArticles),
           let articles = try? JSONDecoder().decode([Article].self, from: data) {
            savedArticles = articles
        }
    }
    
    private func saveSavedArticles() {
        if let data = try? JSONEncoder().encode(savedArticles) {
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.savedArticles)
        }
    }
}
