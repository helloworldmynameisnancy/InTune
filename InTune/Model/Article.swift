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
    static let mockArticle1 = Article(
        url: "https://finance.yahoo.com/news/anonymous-bitcoin-us-seizure-tycoons-093000044.html",
        source: Source(id: nil, name: "Yahoo Entertainment"),
        author: "South China Morning Post",
        title: "How anonymous is bitcoin? US seizure of tycoon's US$13 billion in tokens raises questions",
        description: "The seizure by US authorities of US$13.4 billion worth of bitcoin from an alleged Cambodian criminal has raised questions over the safety of the digital...",
        urlToImage: "https://s.yimg.com/ny/api/res/1.2/GPYlMYtqikSpcZbkWYRH7g--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD04NTc-/https://media.zenfs.com/en/south_china_morning_post_us_228/987ae97535c7adec4f7fde570934d846",
        publishedAt: "2025-10-17T09:30:00Z",
        content: "The seizure by US authorities of US$13.4 billion worth of bitcoin from an alleged Cambodian criminal has raised questions over the safety of the digital assets and prompted frantic speculation in the… [+5470 chars]",
        isBookmarked: true,
        category: "Cryptocurrency"
    )
    
    static let mockArticle2 = Article(
        url: "https://videos.coindesk.com/previews/2gv4H3Y5",
        source: Source(id: nil, name: "CoinDesk"),
        author: "CoinDesk",
        title: "Peter Schiff Challenges Michael Saylor's BTC Strategy",
        description: "Euro Capital CEO Peter Schiff is challenging Michael Saylor's bitcoin strategy over the critical issue of liquidity. The crypto skeptic argued that billions ...",
        urlToImage: "https://media.zenfs.com/en/coindesk_75/5b36dbdca6457294f41b1dddcc73dfe6",
        publishedAt: "2025-09-29T15:49:46Z",
        content: "Euro Capital CEO Peter Schiff is challenging Michael Saylors bitcoin strategy over the critical issue of liquidity. The crypto skeptic argued that billions of dollars in gold could be sold with limit… [+187 chars]",
        isBookmarked: true,
        category: "Cryptocurrency"
    )
}
