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
