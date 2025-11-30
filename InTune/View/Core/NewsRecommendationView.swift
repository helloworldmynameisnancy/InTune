//
//  NewsRecommendationView.swift
//  InTune
//
//  Created by Diana Nguyen on 10/28/25.
//

import SwiftUI

struct NewsRecommendationView: View {
    @State private var viewModel = RecommendationViewModel()
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    @EnvironmentObject var sessionPreferences: SessionPreferences
    @State private var selectedArticle: Article?
    @State private var showQuantitySheet = false
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            BackgroundView()
                        
            VStack(spacing: 0) {
                
                // Back Button to Time Availability View
                HStack {
                    NavigationButton(direction: .back) {
                        path.removeLast(path.count)
                        path.append(Screen.moodReset)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 8)
                    
                    Spacer()
                }
                
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Articles")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Articles curated based on your preferences")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Action Buttons
                        HStack(spacing: 12) {
                            // Refresh Button
                            Button {
                                viewModel.regenerateArticles()
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color("MainColor"))
                            }
                            
                            // Quantity Adjustment Button
                            Button {
                                showQuantitySheet = true
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Content Section
                if viewModel.isLoading {
                    // Loading State
                    VStack(spacing: 20) {
                        Spacer()
                        
                        ProgressView()
                            .scaleEffect(1.2)
                            .tint(Color("MainColor"))
                        
                        Text("Loading recommendations...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.allArticlesShown {
                    // All Articles Shown State
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color("MainColor"))
                        
                        Text("You've seen all articles!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Would you like to answer the questions again or stop here?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        VStack(spacing: 12) {
                            Button {
                                // Navigate back to mood selection
                                path.removeLast(path.count)
                                path.append(Screen.moodReset)
                            } label: {
                                Text("Redo Questions")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("MainColor"))
                                    .cornerRadius(12)
                            }
                            
                            Button {
                                // Go back home
                                path.removeLast(path.count)
                            } label: {
                                Text("Stop")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("MainColor"))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color("MainColor"), lineWidth: 2)
                                    )
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    // Error State
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                        
                        Text("Error Loading Articles")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        VStack(spacing: 12) {
                            Button {
                                // Retry fetching articles
                                Task {
                                    await viewModel.fetchArticles(preferences: sessionPreferences)
                                }
                            } label: {
                                Text("Retry")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("MainColor"))
                                    .cornerRadius(12)
                            }
                            
                            Button {
                                // Go back
                                path.removeLast()
                            } label: {
                                Text("Go Back")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("MainColor"))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color("MainColor"), lineWidth: 2)
                                    )
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.displayedArticles.isEmpty {
                    // Empty State (fallback)
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "newspaper")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No articles available")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Articles List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.displayedArticles) { article in
                                ArticleCard(
                                    article: article,
                                    isBookmarked: savedViewModel.isArticleSaved(article),
                                    onBookmarkToggle: { article in
                                        savedViewModel.toggleBookmark(for: article)
                                    },
                                    onTap: { article in
                                        selectedArticle = article
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(item: $selectedArticle) { article in
            ArticleDetailView(article: article)
        }
        .sheet(isPresented: $showQuantitySheet) {
            QuantityAdjustmentView(
                quantity: Binding(
                    get: { viewModel.articleQuantity },
                    set: { _ in }
                ),
                onUpdate: { newQuantity in
                    viewModel.updateQuantity(newQuantity)
                }
            )
        }
        .onAppear {
            // Fetch articles when view appears (only if not already loaded and not loading)
            if !viewModel.isLoading && viewModel.displayedArticles.isEmpty && viewModel.errorMessage == nil {
                Task {
                    await viewModel.fetchArticles(preferences: sessionPreferences)
                }
            }
        }
    }
}

#Preview {
    NewsRecommendationView(path: .constant(NavigationPath()))
        .environmentObject(SavedArticlesViewModel())
        .environmentObject(SessionPreferences())
}
