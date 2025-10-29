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
    @State private var selectedArticle: Article?
    @State private var showQuantitySheet = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
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
                                print("🎯 NewsRecommendationView - Refresh button tapped")
                                viewModel.regenerateArticles()
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color("MainColor"))
                            }
                            
                            // Quantity Adjustment Button
                            Button {
                                print("🎯 NewsRecommendationView - Ellipsis button tapped")
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
                if viewModel.displayedArticles.isEmpty {
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
                } else {
                    // Articles List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.displayedArticles) { article in
                                ArticleCard(
                                    article: article,
                                    isBookmarked: savedViewModel.isArticleSaved(article),
                                    onBookmarkToggle: { article in
                                        print("🎯 NewsRecommendationView - Bookmark toggle for: \(article.displayTitle)")
                                        savedViewModel.toggleBookmark(for: article)
                                    },
                                    onTap: { article in
                                        print("🎯 NewsRecommendationView - Article tapped: \(article.displayTitle)")
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
        .navigationDestination(item: $selectedArticle) { article in
            ArticleDetailView(article: article)
                .onAppear {
                    print("🎯 NewsRecommendationView - NavigationDestination triggered for: \(article.displayTitle)")
                }
        }
        .sheet(isPresented: $showQuantitySheet) {
            QuantityAdjustmentView(
                quantity: Binding(
                    get: { viewModel.articleQuantity },
                    set: { _ in }
                ),
                onUpdate: { newQuantity in
                    print("🎯 NewsRecommendationView - Quantity updated to: \(newQuantity)")
                    viewModel.updateQuantity(newQuantity)
                }
            )
        }
        .onAppear {
            print("🎯 NewsRecommendationView - View appeared")
        }
    }
}

#Preview {
    NewsRecommendationView()
        .environmentObject(SavedArticlesViewModel())
}
