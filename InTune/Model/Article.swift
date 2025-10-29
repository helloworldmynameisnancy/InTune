//
//  Article.swift
//  InTune
//
//  Created by Diana Nguyen on 10/27/25.
//

import Foundation

// MARK: - Root API Response
struct NewsAPIResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article Model
struct Article: Identifiable, Codable, Hashable {
    // For SwiftUI lists - use URL as stable identifier
    let id: String
    
    // JSON-mapped fields from NewsAPI
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    // App-specific fields (not part of API)
    var isBookmarked: Bool? = false
    var category: String? = nil

    // Custom initializer to set id = url
    init(url: String, source: Source?, author: String?, title: String?, description: String?, urlToImage: String?, publishedAt: String?, content: String?, isBookmarked: Bool? = false, category: String? = nil) {
        self.id = url  // Use URL as stable identifier
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.isBookmarked = isBookmarked
        self.category = category
    }

    // Computed helpers for cleaner UI use
    var displayTitle: String { title ?? "Untitled Article" }
    var displayAuthor: String { author ?? "Unknown Author" }
    var displaySource: String { source?.name ?? "Unknown Source" }
    var imageURL: URL? {
        guard let urlToImage else { return nil }
        return URL(string: urlToImage)
    }
    var articleURL: URL? {
        guard let url else { return nil }
        return URL(string: url)
    }
}

// MARK: - Source Submodel
struct Source: Codable, Equatable, Hashable {
    let id: String?
    let name: String?
}

// MARK: - Mock Data for Preview/Testing
extension Article {
    // Mock data removed - using Article.recommendedArticles from NewsRecommendations.swift instead
}
