import Foundation

// MARK: - Error Enum
enum NewsAPIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(String)
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid API response"
        case .decodingError(let message):
            return "Failed to decode response: \(message)"
        case .apiError(let message):
            return "API error: \(message)"
        }
    }
}

// MARK: - Response Models
struct NewsAPIAIResponse: Codable {
    let articles: NewsAPIAIArticlesContainer
    let totalResults: Int?
    let moreResultsAvailable: Bool?
}

struct NewsAPIAIArticlesContainer: Codable {
    let results: [NewsAPIAIArticle]
    let pages: Int?
    let currentPage: Int?
}

struct NewsAPIAIArticle: Codable {
    let uri: String
    let url: String?
    let title: String?
    let body: String?
    let source: NewsAPIAISource?
    let authors: [NewsAPIAIAuthor]?
    let image: String?
    let dateTimePub: String?
    let sentiment: NewsAPIAISentiment?
    let lang: String?
    let categories: [NewsAPIAICategory]?  // Article categories from API
    
    // Custom decoder to handle sentiment as either number or object
    enum CodingKeys: String, CodingKey {
        case uri, url, title, body, source, authors, image, dateTimePub, sentiment, lang, categories
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        uri = try container.decode(String.self, forKey: .uri)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        body = try container.decodeIfPresent(String.self, forKey: .body)
        source = try container.decodeIfPresent(NewsAPIAISource.self, forKey: .source)
        authors = try container.decodeIfPresent([NewsAPIAIAuthor].self, forKey: .authors)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        dateTimePub = try container.decodeIfPresent(String.self, forKey: .dateTimePub)
        lang = try container.decodeIfPresent(String.self, forKey: .lang)
        categories = try container.decodeIfPresent([NewsAPIAICategory].self, forKey: .categories)
        
        // Handle sentiment as either Double or NewsAPIAISentiment object
        if let sentimentDouble = try? container.decode(Double.self, forKey: .sentiment) {
            // Sentiment is a number, create NewsAPIAISentiment with just the score
            sentiment = NewsAPIAISentiment(score: sentimentDouble, label: nil)
        } else if let sentimentObject = try? container.decode(NewsAPIAISentiment.self, forKey: .sentiment) {
            // Sentiment is an object
            sentiment = sentimentObject
        } else {
            // No sentiment field or null
            sentiment = nil
        }
    }
}

struct NewsAPIAISource: Codable {
    let uri: String?
    let title: String?
    let dataType: String?
}

struct NewsAPIAIAuthor: Codable {
    let name: String?
    let uri: String?
}

struct NewsAPIAISentiment: Codable {
    let score: Double?
    let label: String?
}

struct NewsAPIAICategory: Codable {
    let uri: String?
    let label: String?
    let parentUri: String?
}

// MARK: - Article Conversion Extension
extension NewsAPIAIArticle {
    /// Converts NewsAPI.ai article to app's Article model
    /// - Parameter category: Optional category name to assign to the article (e.g., "Business", "Technology")
    func toArticle(category: String? = nil) -> Article? {
        // Use url if available, otherwise use uri
        let articleUrl = url ?? uri
        
        // Ensure we have a valid URL/URI
        guard !articleUrl.isEmpty else {
            print("⚠️ [Article Conversion] Skipping article - no URL/URI")
            return nil
        }
        
        // Filter: Only include articles that have both an image and an author
        let hasValidImage = image != nil && !image!.isEmpty && (image!.hasPrefix("http://") || image!.hasPrefix("https://"))
        let hasValidAuthor = authors != nil && !authors!.isEmpty && authors!.first?.name != nil && !authors!.first!.name!.isEmpty
        
        guard hasValidImage && hasValidAuthor else {
            print("⚠️ [Article Conversion] Skipping article - missing image or author")
            print("   - Title: \(title ?? "No title")")
            print("   - Has valid image: \(hasValidImage)")
            print("   - Has valid author: \(hasValidAuthor)")
            return nil
        }
        
        // Extract source name
        let sourceName = source?.title
        let sourceId = source?.uri
        
        // Create Source object
        let articleSource = Source(id: sourceId, name: sourceName)
        
        // Extract author (use first author if available)
        let articleAuthor = authors?.first?.name
        
        // Use body prefix for description, full body for content
        let articleDescription = body.map { String($0.prefix(200)) }
        let articleContent = body
        
        // Extract image URL
        let articleImageUrl = image
        
        // Extract publish date
        let articlePublishDate = dateTimePub
        
        // Extract category from API response (if available), otherwise use provided category
        let articleCategory: String? = {
            // First, try to get category from API response
            if let categories = categories, !categories.isEmpty {
                // Map of category URIs to display names
                let categoryMap: [String: String] = [
                    "news/Technology": "Technology",
                    "news/Business": "Business",
                    "news/Politics": "Politics",
                    "news/Health": "Health",
                    "news/Sports": "Sports",
                    "news/Science": "Science"
                ]
                
                // Find first matching category from our selected categories
                for category in categories {
                    if let uri = category.uri,
                       let displayName = categoryMap[uri] {
                        return displayName
                    }
                }
                
                // If no match, use the label from the first category
                if let firstCategory = categories.first,
                   let label = firstCategory.label {
                    // Extract category name from label (e.g., "news/Technology" -> "Technology")
                    if label.contains("/") {
                        return String(label.split(separator: "/").last ?? "")
                    }
                    return label
                }
            }
            
            // Fallback to provided category parameter
            return category
        }()
        
        return Article(
            url: articleUrl,
            source: articleSource,
            author: articleAuthor,
            title: title,
            description: articleDescription,
            urlToImage: articleImageUrl,
            publishedAt: articlePublishDate,
            content: articleContent,
            isBookmarked: false,
            category: articleCategory
        )
    }
}

// MARK: - NewsAPI.ai Service
class NewsAPIAIService {
    private let apiKey: String
    private let baseURL = "https://newsapi.ai/api/v1/article/getArticles"
    
    init() {
        self.apiKey = APIKeys.newsAPIAI
    }
    
    /// Builds API request body from SessionPreferences
    private func buildRequest(preferences: SessionPreferences) -> [String: Any] {
        var params: [String: Any] = [
            "action": "getArticles",
            "apiKey": apiKey,
            "resultType": "articles",
            "dataType": ["news"],
            "lang": "eng",
            "articlesSortBy": "relevance",
            "articlesCount": preferences.articleCount,  // 100
            "articlesPage": 1
        ]
        
        // 1. Sentiment filtering (from mood)
        let sentimentRange = preferences.targetSentimentRange
        params["sentimentMin"] = sentimentRange.min
        params["sentimentMax"] = sentimentRange.max
        
        // 2. Category filtering (from topics)
        let categoryUris = preferences.newsAPIAICategoryUris
        if !categoryUris.isEmpty {
            params["categoryUri"] = categoryUris
        }
        
        // 2.5. Include article categories in response (for accurate category detection)
        params["includeArticleCategories"] = true
        
        // 3. Keyword exclusion using ignoreKeyword (better than -keyword)
        // Supports up to 60 keywords (vs 15 for keyword parameter)
        let exclusionKeywords = preferences.exclusionKeywords
        if !exclusionKeywords.isEmpty {
            // Split each exclusion pattern by OR and extract individual keywords
            let allKeywords = exclusionKeywords.flatMap { pattern in
                pattern.components(separatedBy: " OR ").map { $0.trimmingCharacters(in: .whitespaces) }
            }
            // Use ignoreKeyword instead of keyword with minus prefix
            // This is more reliable and supports more keywords
            params["ignoreKeyword"] = allKeywords
            // Search both title and body for exclusion keywords (more thorough filtering)
            params["ignoreKeywordLoc"] = "body,title"
        }
        
        // 4. Source quality filtering - prioritize top 10% of sources (highest quality)
        params["startSourceRankPercentile"] = 90
        
        // 5. Duplicate filtering - skip duplicate articles for more variety
        params["isDuplicateFilter"] = "skipDuplicates"
        
        return params
    }
    
    /// Fetches articles from NewsAPI.ai based on session preferences
    func fetchArticles(preferences: SessionPreferences, count: Int = 100) async throws -> [Article] {
        let requestBody = buildRequest(preferences: preferences)
        
        guard let url = URL(string: baseURL) else {
            print("❌ [NewsAPIAIService] Invalid URL: \(baseURL)")
            throw NewsAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ [NewsAPIAIService] Invalid response type")
            throw NewsAPIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            print("❌ [NewsAPIAIService] Non-200 status code: \(httpResponse.statusCode)")
            // Try to read error message from response
            if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let message = errorData["message"] as? String {
                    print("❌ [NewsAPIAIService] Error message: \(message)")
                    throw NewsAPIError.apiError(message)
                }
            }
            throw NewsAPIError.invalidResponse
        }
        
        // Check for error response first
        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let errorMessage = jsonObject["error"] as? String {
            print("❌ [NewsAPIAIService] API returned error: \(errorMessage)")
            throw NewsAPIError.apiError(errorMessage)
        }
        
        // Decode response
        do {
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(NewsAPIAIResponse.self, from: data)
            
            // Extract fallback category name from selected topics (used if API doesn't provide categories)
            // Note: With includeArticleCategories=true, API will provide actual categories for each article
            let fallbackCategory: String? = {
                guard let firstTopic = preferences.topics.first else { return nil }
                // Skip "Surprise Me" - no category for that
                if firstTopic == "🎲 Surprise Me" {
                    return nil
                }
                // Extract category name by removing emoji prefix (e.g., "💼 Business" -> "Business")
                let parts = firstTopic.split(separator: " ", maxSplits: 1)
                return parts.count > 1 ? String(parts[1]) : nil
            }()
            
            // Convert articles - categories will be extracted from API response if available
            let convertedArticles = apiResponse.articles.results.compactMap {
                        $0.toArticle(category: fallbackCategory)}
                    
            let lengthRange = preferences.targetWordRange
            let filteredArticles: [Article]

            if let range = lengthRange {
                filteredArticles = convertedArticles.filter { article in
                    // Use body as fallback
                    let text = article.content ?? article.description ?? ""
                    let wc = text.wordCount
                    
                    // Long reads only require min
                    if range.max == Int.max {
                        return wc >= range.min
                    } else {
                        return wc >= range.min && wc <= range.max
                    }
                }
            } else {
                filteredArticles = convertedArticles
            }

            print("🔵 [NewsAPIAIService] Filtered \(filteredArticles.count) articles for range \(lengthRange ?? (0,0))")
            
            return filteredArticles
        } catch {
            print("❌ [NewsAPIAIService] Decoding error: \(error)")
            print("❌ [NewsAPIAIService] Error details: \(error.localizedDescription)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("❌ [NewsAPIAIService] Missing key: \(key.stringValue) at path: \(context.codingPath)")
                case .typeMismatch(let type, let context):
                    print("❌ [NewsAPIAIService] Type mismatch: expected \(type) at path: \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("❌ [NewsAPIAIService] Value not found: \(type) at path: \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("❌ [NewsAPIAIService] Data corrupted at path: \(context.codingPath), \(context.debugDescription)")
                @unknown default:
                    print("❌ [NewsAPIAIService] Unknown decoding error")
                }
            }
            throw NewsAPIError.decodingError(error.localizedDescription)
        }
    }
}

extension String {
    /// Returns the number of words in a string
    var wordCount: Int {
        return self.split { $0.isWhitespace || $0.isNewline }.count
    }
}
