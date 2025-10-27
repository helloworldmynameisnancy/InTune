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
struct Article: Identifiable, Codable {
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
struct Source: Codable {
    let id: String?
    let name: String?
}

// MARK: - Mock Data for Preview/Testing
extension Article {
    static let mockArticle1 = Article(
        url: "https://example.com/article1",
        source: Source(id: "techcrunch", name: "TechCrunch"),
        author: "Bart Jansen",
        title: "Apple, Google, Meta must face lawsuits over casino-style gambling apps",
        description: "A federal judge ruled that Apple, Google, and Meta must face lawsuits alleging they facilitated illegal gambling through casino-style apps.",
        urlToImage: nil,
        publishedAt: "2024-01-15T10:30:00Z",
        content: "Full article content here...",
        isBookmarked: false,
        category: "Technology"
    )
    
    static let mockArticle2 = Article(
        url: "https://example.com/article2",
        source: Source(id: "reuters", name: "Reuters"),
        author: "Sarah Johnson",
        title: "New AI breakthrough promises faster medical diagnosis",
        description: "Researchers develop AI system that can diagnose diseases 10x faster than current methods.",
        urlToImage: nil,
        publishedAt: "2024-01-14T15:45:00Z",
        content: "Full article content here...",
        isBookmarked: true,
        category: "Health"
    )
    
    static let mockArticle3 = Article(
        url: "https://example.com/article3",
        source: Source(id: "bbc", name: "BBC News"),
        author: "Andy Corbley",
        title: "Gaza doctors are starving while fighting to save lives, evacuated medic tells BBC",
        description: "Medical professionals in Gaza face extreme conditions as they struggle to provide care amid ongoing conflict.",
        urlToImage: nil,
        publishedAt: "2024-01-13T08:15:00Z",
        content: "Full article content here...",
        isBookmarked: true,
        category: "Politics"
    )
    
    static let mockArticle4 = Article(
        url: "https://example.com/article4",
        source: Source(id: "guardian", name: "The Guardian"),
        author: "James Smith",
        title: "100,000 New Jobs Will Clean Up the Coastline and Protect Species from Plastic, Overde...",
        description: "Massive environmental initiative creates employment opportunities while addressing ocean pollution crisis.",
        urlToImage: nil,
        publishedAt: "2024-01-12T14:20:00Z",
        content: "Full article content here...",
        isBookmarked: true,
        category: "Environment"
    )
    
    static let mockArticle5 = Article(
        url: "https://example.com/article5",
        source: Source(id: "cnn", name: "CNN"),
        author: "Amber Le",
        title: "2-in-1 Inhaler Reduces Asthma Attacks in Children by 45% Shows New Study",
        description: "Revolutionary medical device combines two medications to significantly improve pediatric asthma treatment outcomes.",
        urlToImage: nil,
        publishedAt: "2024-01-11T11:45:00Z",
        content: "Full article content here...",
        isBookmarked: true,
        category: "Health"
    )
    
    static let mockArticle6 = Article(
        url: "https://example.com/article6",
        source: Source(id: "ap", name: "Associated Press"),
        author: "Wilson Chen",
        title: "Trump pulls nomination of E.J. Antoni to lead Bureau of Labor Statistics, AP source says",
        description: "Administrative changes in federal labor statistics leadership as nomination is withdrawn.",
        urlToImage: nil,
        publishedAt: "2024-01-10T16:30:00Z",
        content: "Full article content here...",
        isBookmarked: true,
        category: "Politics"
    )
    
    static let mockArticle7 = Article(
        url: "https://example.com/article7",
        source: Source(id: "nasa", name: "NASA"),
        author: "Dr. Maria Rodriguez",
        title: "James Webb Space Telescope's First Look at an Atmosphere on Distant Exoplanet",
        description: "Groundbreaking observations reveal atmospheric composition of exoplanet located 700 light-years away.",
        urlToImage: nil,
        publishedAt: "2024-01-09T09:00:00Z",
        content: "Full article content here...",
        isBookmarked: true,
        category: "Technology"
    )
}
