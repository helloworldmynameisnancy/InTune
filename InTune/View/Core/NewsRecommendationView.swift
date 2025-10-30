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
    @Environment(\.dismiss) var dismiss
    @State private var selectedArticle: Article?
    @State private var showQuantitySheet = false
    
    var body: some View {
        ZStack {
            BackgroundView()
                        
            VStack(spacing: 0) {
                
                // Back Button to Time Availability View
                HStack {
                    NavigationButton(direction: .back) {
                        dismiss()
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
    }
}

#Preview {
    NewsRecommendationView()
        .environmentObject(SavedArticlesViewModel())
}
