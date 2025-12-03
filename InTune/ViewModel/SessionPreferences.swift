//
//  SessionPreferences.swift
//  InTune
//
//  Created by Nancy Luu on 11/29/25.
//
import Foundation
import Combine

class SessionPreferences: ObservableObject {
    @Published var mood: String = ""
    @Published var topics: [String] = []
    @Published var topicExclusions: [String] = []
    @Published var timeAvailability: String = ""
    
    func reset() {
        mood = ""
        topics = []
        topicExclusions = []
        timeAvailability = ""
    }
}

// MARK: - API Mapping Extension
extension SessionPreferences {
    /// Maps mood to sentiment score range for NewsAPI.ai filtering
    /// Sentiment scores range from -1.0 (very negative) to +1.0 (very positive)
    var targetSentimentRange: (min: Double, max: Double) {
        switch mood {
        case "😊 Happy / Positive":
            return (0.2, 1.0)  // Strongly positive content
        case "😐 Neutral / Just browsing":
            return (-0.3, 0.3)  // Balanced, neutral content (widened for better results)
        case "😟 Anxious / Worried":
            return (0.1, 0.5)  // Calming, avoiding very negative
        case "🤔 Curious / Interested":
            return (-0.2, 0.9)  // Wide range, diverse content
        case "😴 Tired / Low energy":
            return (0.2, 0.5)  // Light, positive content
        default:
            return (-1.0, 1.0)  // No filter (fallback)
        }
    }
    
    /// Maps topic selections to NewsAPI.ai category URIs
    /// Returns array of category URIs for selected topics (excluding "Surprise me")
    /// Format: "news/CategoryName" (as returned by suggestCategoriesFast API)
    var newsAPIAICategoryUris: [String] {
        topics.compactMap { topic in
            switch topic {
            case "💻 Technology":
                return "news/Technology"
            case "💼 Business":
                return "news/Business"
            case "🏛 Politics":
                return "news/Politics"
            case "🩺 Health":
                return "news/Health"
            case "⚽ Sports":
                return "news/Sports"
            case "🔬 Science":
                return "news/Science"
            case "🎲 Surprise me":
                return nil  // No category filter for "Surprise me"
            default:
                return nil
            }
        }
    }
    
    /// Maps exclusions to keyword exclusion patterns for API filtering
    /// Returns array of keyword patterns to exclude (without parentheses)
    /// Note: ignoreKeyword supports up to 60 keywords, so we can be more comprehensive
    var exclusionKeywords: [String] {
        topicExclusions.compactMap { exclusion in
            switch exclusion {
            case "❌ Health & Disease":
                // Comprehensive health/disease exclusion keywords (15 words - all single words to stay within limit)
                return "pandemic OR outbreak OR epidemic OR virus OR disease OR infection OR illness OR emergency OR crisis OR coronavirus OR covid OR flu OR influenza OR sickness OR diagnosis"
            case "❌ Politics":
                // Comprehensive politics exclusion keywords (15 keywords)
                return "politics OR political OR election OR government OR partisan OR president OR senator OR congress OR campaign OR politician OR voting OR ballot OR legislation OR policy OR democracy"
            case "❌ Violence":
                // Comprehensive violence exclusion keywords (15 keywords - broader than just crime, includes all forms of violence)
                return "violent OR murder OR homicide OR killing OR shooting OR attack OR assault OR death OR altercation OR confrontation OR conflict OR beating OR battery OR stabbing OR fighting"
            case "❌ Gossip":
                // Comprehensive gossip exclusion keywords (15 keywords)
                return "gossip OR scandal OR tabloid OR celebrity OR paparazzi OR affair OR breakup OR divorce OR dating OR romance OR Hollywood OR star OR actor OR actress OR rumor"
            case "🚫 No filters":
                return nil
            default:
                return nil
            }
        }
    }
    
    /// Returns estimated article word count range for the selected time availability (adjusted for typical reading behavior)
    var targetWordRange: (min: Int, max: Int)? {
        switch timeAvailability {
        case "⏳ Under 2 minutes":
            return (0, 350)       // Quick reads

        case "⏳ 5–10 minutes":
            return (350, 700)    // Medium-length reads

        case "⏳ 10+ minutes":
            return (700, Int.max)   // Long-form articles

        case "🕰 Just browsing / no rush":
            return nil            // No filtering

        default:
            return nil
        }
    }
    
    /// Returns article count for API request
    /// Always returns 100 - all time options fetch same amount, filtering happens client-side
    var articleCount: Int {
        return 100
    }
}
