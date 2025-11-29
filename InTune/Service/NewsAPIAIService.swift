import Foundation

class NewsAPIAIService {
    private let apiKey: String
    private let baseURL = "https://newsapi.ai/api/v1/article/getArticles"
    
    init() {
        self.apiKey = APIKeys.newsAPIAI
    }
    
    /// Simple test to verify API connection works
    func testConnection() async throws -> Bool {
        // Minimal request - just get 3 articles, no filters
        let requestBody: [String: Any] = [
            "action": "getArticles",
            "apiKey": apiKey,
            "resultType": "articles",
            "dataType": ["news"],
            "articlesCount": 3,  // Just get 3 articles for testing
            "articlesPage": 1,
            "articlesSortBy": "date",
            "lang": "eng"
        ]
        
        guard let url = URL(string: baseURL) else {
            print("❌ Invalid URL")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        print("📡 Making API request to NewsAPI.ai...")
        print("🔑 Using API key: \(String(apiKey.prefix(8)))...") // Show first 8 chars only
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Invalid response")
            return false
        }
        
        print("📥 Response status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            // Try to read error message
            if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("❌ API Error Response:")
                print(errorData)
                
                if let message = errorData["message"] as? String {
                    print("❌ Error message: \(message)")
                }
            } else {
                print("❌ Failed to parse error response")
            }
            return false
        }
        
        // Try to parse response
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            print("✅ API Response received!")
            print("📋 Response keys: \(json.keys)")
            
            if let articles = json["articles"] as? [String: Any],
               let results = articles["results"] as? [[String: Any]] {
                print("✅ Found \(results.count) articles")
                
                // Print first article details if available
                if let firstArticle = results.first {
                    print("\n📰 Sample Article:")
                    if let title = firstArticle["title"] as? String {
                        print("   Title: \(title)")
                    }
                    if let source = firstArticle["source"] as? [String: Any],
                       let sourceName = source["title"] as? String {
                        print("   Source: \(sourceName)")
                    }
                    if let dateTime = firstArticle["dateTimePub"] as? String {
                        print("   Published: \(dateTime)")
                    }
                }
                
                return true
            } else {
                print("⚠️ Response received but 'articles.results' not found")
                print("📄 Full response structure:")
                print(json)
            }
        }
        
        print("⚠️ Response received but couldn't parse as JSON")
        return false
    }
}

